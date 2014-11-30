%       sample invocations:
%               wf = P3WorkflowClassifierGridSearch(p3train, {@trainTestSplitMx});
%
% function w = P3WorkflowClassifierGridSearch(p3train, splitCell, classifiers='dummy\all\slow\fast\fastest', balancing='yes\no\only')

function w = P3WorkflowClassifierGridSearch(p3train, splitCell, classifiers='all', balancing='no', 
                                              cvalues=[1000, 100, 10, 5, 1, 0.5, 0.1, 0.05, 0.01], 
                                              gammas=[0.0001 0.0005 0.001 0.05 0.01 0.1 1],
                                              lambdas=[0 0.001 0.01 0.1 1 10])
%                                                  cvalues=[], gammas=[0.05, 0.01], lambdas=[])

%      printf('passing to the testflow: onlyFast: %d, onlySlow: %d\n', classifiers='all'); fflush(stdout);
    w=P3Workflow(p3train, splitCell);
    
    max_iterations_values=[125];
    hidden_neurons_values=[32];

    
    w=addFunction(w, 'featsCompute',    @featsComputePassThrough);
    w=addFunction(w, 'featsSelect',     @featsSelectPassThrough);
    
    % %%%%%%%%%%%%% PARSE PARAMATERS %%%%%%%%%%%% %

    units_only = strcmp(balancing, 'no');
    balanced_only = strcmp(balancing, 'only');
    
    %Dummy classifier to check the summary consistency
    if(strcmp(classifiers, 'dummy')==true)
        w=addFunction(w, 'trainTest', @DummyClassifier);
    endif;

    if(strcmp(classifiers, 'fast')==true || strcmp(classifiers, 'all')==true)
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
    endif;
    if(strcmp(classifiers, 'fast')==true || strcmp(classifiers, 'fastest')==true || strcmp(classifiers, 'all')==true)
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
    
    if(strcmp(classifiers, 'all')==true || strcmp(classifiers, 'slow')==true)
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