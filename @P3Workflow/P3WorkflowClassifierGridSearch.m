%       sample invocations:
%               wf = P3WorkflowClassifierGridSearch(p3train, {@trainTestSplitMx});
%
% function w = P3WorkflowClassifierGridSearch(p3train, splitCell, classifiers='all\fast\slow', balancing='yes\no\only')

function w = P3WorkflowClassifierGridSearch(p3train, splitCell, classifiers='all', balancing='no')

%      printf('passing to the testflow: onlyFast: %d, onlySlow: %d\n', classifiers='all'); fflush(stdout);

    w=P3Workflow(p3train, splitCell);
    
    %lambdas are for logistic regression and neural networks
   lambdas=[0 0.001 0.01 0.1 1 10];
   nn_lambdas=[0 0.001 0.01 0.1 1];


    %c parameter values for SVM training
      cvalues=[100, 10, 1, 0.1, 0.01];
%  cvalues=[10, 1, 0.1];


    %gamma parameter values for FLDA
   gammas=[0.0001, 0.001, 0.01, 0.1, 1];
%   gammas=[0.0001, 0.01, 1, 10];
%   gammas=[0.01, 1];


    %neural networks have 3 tuning parameters: lambda, size of the hidden layer and max training iterations
    %max_iterations_values=[150 300 400];
    max_iterations_values=[125];
    hidden_neurons_values=[32];

    
    w=addFunction(w, 'featsCompute',    @featsComputePassThrough);
    w=addFunction(w, 'featsSelect',     @featsSelectPassThrough);
    
    % %%%%%%%%%%%%% PARSE PARAMATERS %%%%%%%%%%%% %

    units_only = strcmp(balancing, 'no');
    balanced_only = strcmp(balancing, 'only');
    
    

    if(strcmp(classifiers, 'slow')==false)
        %LINEAR SVMs
        for(c=cvalues)
            %register several flavors of SVM
            MODE=struct();
            MODE.TYPE='SVM';
            MODE.hyperparameter.c_value=c;
            if(~units_only)
                w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNan, MODE});
            endif;
            if(~balanced_only)
                w=addFunction(w, 'trainTest', @ClassifierNan, MODE);
            endif;
        endfor;

        %FLDAs
        for(gamma=gammas)
            MODE=struct();
            MODE.TYPE='FLDA';
            MODE.hyperparameter.gamma=gamma;
            if(~units_only)
                w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNan, MODE});
            endif;
            if(~balanced_only)
                w=addFunction(w, 'trainTest', @ClassifierNan, MODE);
            endif;
        endfor;

    endif;
    
    if(strcmp(classifiers, 'fast')==false)
        %LOGISTIC REGRESSIONs
        for(lambda = lambdas)
            for(max_iterations=max_iterations_values)
                %register several flavors of LogisticRegression
                if(~units_only)
                    w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierLogReg, max_iterations, lambda});
                endif;
                if(~balanced_only)
                    w=addFunction(w, 'trainTest', @ClassifierLogReg, max_iterations, lambda);
                endif;
            endfor;
        endfor;
        
        %Neural Networks
        for(lambda=lambdas(3:end))
            for(hidden_neurons = hidden_neurons_values)
                for(max_iterations = max_iterations_values)
                    if(~units_only)
                        w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNN, hidden_neurons, max_iterations, lambda });
                    endif;
                    if(~balanced_only)
                        w=addFunction(w, 'trainTest', @ClassifierNN, hidden_neurons, max_iterations, lambda );
                    endif;
                endfor;
            endfor;
        endfor;
    endif;
endfunction;