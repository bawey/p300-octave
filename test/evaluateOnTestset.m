
%function somesummary = evaluateOnTestset(p3train, p3test, teststring)
% this function takes in the train data, test data and test string
% it trains several models using the training data and evaluates them on the testset
% reports back with summaries

function somesummary = evaluateOnTestset(p3train, p3test, teststring)
    p3m=P3SessionMerge(p3train, P3SessionAddLabels(p3test, teststring));

    w=P3Workflow(p3m, {@trainTestSplitMerged, p3train.periodsCount});

    w=addFunction(w, 'featsCompute',    @featsComputePassThrough);
    w=addFunction(w, 'featsSelect',     @featsSelectPassThrough);    


    %lambdas are for logistic regression and neural networks
    lambdas=[0 0.001 0.01 0.1 1 10 100];

    %c parameter values for SVM training
    cvalues=[100, 10, 1, 0.1, 0.01, 0.001, 0.0001];

    %gamma parameter values for SVM with gaussian kernel
    gammas=[0.0001, 0.0005, 0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1, 5, 10];


    %neural networks have 3 tuning parameters: lambda, size of the hidden layer and max training iterations
    %max_iterations_values=[150 300 400];
    max_iterations_values=[100];
    hidden_neurons_values=[32 64];


        %LINEAR SVMs
        for(c=cvalues)
            %register several flavors of SVM
            MODE=struct();
            MODE.TYPE='SVM';
            MODE.hyperparameter.c_value=c;
            w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNan, MODE});
        endfor;

        %FLDAs
        for(gamma=gammas)
            MODE=struct();
            MODE.TYPE='FLDA';
            MODE.hyperparameter.gamma=gamma;
            w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNan, MODE});
        endfor;

        %LOGISTIC REGRESSIONs
        for(lambda = lambdas)
            for(max_iterations=max_iterations_values)
                %register several flavors of LogisticRegression
                w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierLogReg, max_iterations, lambda});
            endfor;
        endfor;
        
        %Neural Networks
        for(lambda=lambdas(3:end))
            for(hidden_neurons = hidden_neurons_values)
                for(max_iterations = max_iterations_values)
                      w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNN, hidden_neurons, max_iterations, lambda });
                endfor;
            endfor;
        endfor;
      
    somesummary=launch(w);

    summarize(somesummary);
    
endfunction;
