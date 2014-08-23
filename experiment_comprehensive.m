%this function aims to evaluate all the methods via training with crossvalidation of numerous partitionings of train set
function [summary, fc, fs, tt, title] = experiment_comprehensive(p3train, title, splitsCount=p3train.periodsCount)
    init();

    %some structures for pretty printing
    fc={};
    fs={};
    tt={};

    %lambdas are for logistic regression and neural networks
    %lambdas=[0,pow2(0:0.75:11)/100];
    lambdas=[0 0.01 0.02 0.04 0.08 1 2 4 8];

    %c parameter values for SVM training
    cvalues=1./lambdas(2:end);

    %gamma parameter values for SVM with gaussian kernel
    gammas=[0.1, 0.25, 0.75, 0.5, 1, 1.5, 2, 3, 4];


    %neural networks have 3 tuning parameters: lambda, size of the hidden layer and max training iterations
    max_iterations_values=[150 300 400];
    hidden_neurons_values=[16 64 128 256 512];

    %"OBJECT-ORIENTED"

    %Number of splits before. train-crossvalidate will be performed for each split.
    %For the best results, set splits number equal to the number of periods in train data (terribly long computation though)

    w=P3Workflow(p3train, @trainTestSplitMx, {splitsCount});
    w=addFunction(w, 'featsCompute',    @featsComputePassThrough);  fc{end+1}='pass-through';
    w=addFunction(w, 'featsSelect',     @featsSelectPassThrough);   fs{end+1}='pass-through';

    %LOGISTIC REGRESSIONs
    for(lambda = lambdas)
        %register several flavors of LogisticRegression
        %w=addFunction(w, 'trainTest', @ClassifierLogReg, 400, lambda); tt{end+1}=sprintf('LogReg (lambda=%.3f)',lambda);
    endfor;

    %LINEAR SVMs
    for(c=cvalues)
        %register several flavors of SVM
        MODE=struct();
        MODE.TYPE='SVM';
        MODE.hyperparameter.c_value=c;
        %w=addFunction(w, 'trainTest', @ClassifierNan, MODE); tt{end+1}=sprintf('Linear SVM (c=%.3f)',c);
    endfor;

    %RADIAL BASIS (GAUSSIAN) KERNEL SVMs
    for(c=cvalues)
        for(gamma=gammas)
            MODE=struct();
            MODE.TYPE='SVM';
            MODE.hyperparameter.c_value=c;
            MODE.hyperparameter.gamma=gamma;
           % w=addFunction(w, 'trainTest', @ClassifierNan, MODE); tt{end+1}=sprintf('Gaussian kernel SVM (c=%.3f, gamma=%.3f)',c, gamma);
        endfor;
    endfor;

    %FDAs
    for(gamma=gammas)
        MODE=struct();
        MODE.TYPE='FLDA';
        MODE.hyperparameter.gamma=gamma;
        %w=addFunction(w, 'trainTest', @ClassifierNan, MODE); tt{end+1}=sprintf('%s (gamma=%.3f)', MODE.TYPE, gamma);
    endfor;

    %Neural Networks
    for(lambda=lambdas)
        for(hidden_neurons = hidden_neurons_values)
            for(max_iterations = max_iterations_values)
                w=addFunction(w, 'trainTest', @ClassifierNN, hidden_neurons, max_iterations, lambda ); tt{end+1}=sprintf('%s (gamma=%.3f)', MODE.TYPE, gamma);
            endfor;
        endfor;
    endfor;


    printf('launching workflow...'); fflush(stdout);
    summary=launch(w, fc, fs, tt, title);

    summarize(summary, fc, fs, tt);
    %summary should return the best setup. or sort everything according to (recall+presision)
    
endfunction;