function w = P3WorkflowClassifierGridSearch(p3train, splitCell)
    w=P3Workflow(p3train, splitCell);
    
    %lambdas are for logistic regression and neural networks
    lambdas=[0 0.001 0.01 0.1 1 10 100];

    %c parameter values for SVM training
    cvalues=[100, 10, 1, 0.1, 0.01, 0.001, 0.0001];

    %gamma parameter values for SVM with gaussian kernel
    gammas=[0.0001, 0.0005, 0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1, 5, 10];


    %neural networks have 3 tuning parameters: lambda, size of the hidden layer and max training iterations
    %max_iterations_values=[150 300 400];
    max_iterations_values=[175];
    hidden_neurons_values=[32 256 512];

    %"OBJECT-ORIENTED"

    w=addFunction(w, 'featsCompute',    @featsComputePassThrough);
    w=addFunction(w, 'featsSelect',     @featsSelectPassThrough);


    
    %LOGISTIC REGRESSIONs
    for(lambda = lambdas)
        %register several flavors of LogisticRegression
%          w=addFunction(w, 'trainTest', @ClassifierLogReg, 150, lambda);
    endfor;

    %LINEAR SVMs
    for(c=cvalues)
        %register several flavors of SVM
        MODE=struct();
        MODE.TYPE='SVM';
        MODE.hyperparameter.c_value=c;
        w=addFunction(w, 'trainTest', @ClassifierNan, MODE);
    endfor;

    %RADIAL BASIS (GAUSSIAN) KERNEL SVMs
    for(c=cvalues)
        for(gamma=gammas)
            MODE=struct();
            MODE.TYPE='RBF';
            MODE.hyperparameter.c_value=c;
            MODE.hyperparameter.gamma=gamma;
%              w=addFunction(w, 'trainTest', @ClassifierNan, MODE);
        endfor;
    endfor;

    %FLDAs
    for(gamma=gammas)
        MODE=struct();
        MODE.TYPE='FLDA';
%          MODE.hyperparameter.gamma=gamma;
%          w=addFunction(w, 'trainTest', @ClassifierNan, MODE);
    endfor;

    %Neural Networks
    for(lambda=lambdas(3:end))
        for(hidden_neurons = hidden_neurons_values)
            for(max_iterations = max_iterations_values)
%                w=addFunction(w, 'trainTest', @ClassifierNN, hidden_neurons, max_iterations, lambda );
            endfor;
        endfor;
    endfor;

endfunction;