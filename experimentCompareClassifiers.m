%this function aims to evaluate all the methods via training with crossvalidation of numerous partitionings of train set
%   experimentCompareClassifiers( trainingP3Session, "title", splitsCount=trainingP3Session.periodsCount )

function [summary, fc, fs, tt, title] = experimentCompareClassifiers(p3train, title, splitsCount=p3train.periodsCount)
    init();

    %some structures for pretty printing
    fc={};
    fs={};
    tt={};

    %lambdas are for logistic regression and neural networks
    %lambdas=[0,pow2(0:0.75:11)/100];
    %lambdas=[0 0.01 0.05 0.1 0.5 1 2 4 8];
    lambdas=[0 0.1 1 10 100];

    %c parameter values for SVM training
    cvalues=[100, 10, 1, 0.1, 0.01, 0.001, 0.0001];

    %gamma parameter values for SVM with gaussian kernel
    gammas=[0.0001, 0.0005, 0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1, 5, 10];


    %neural networks have 3 tuning parameters: lambda, size of the hidden layer and max training iterations
    %max_iterations_values=[150 300 400];
    max_iterations_values=[175];
    hidden_neurons_values=[32 256 512];

    %"OBJECT-ORIENTED"

    %Number of splits before. train-crossvalidate will be performed for each split.
    %For the best results, set splits number equal to the number of periods in train data (terribly long computation though)

    w=P3Workflow(p3train, @trainTestSplitMx, {splitsCount});
    
    
    extended=true;
    if(extended==true)
        w=addFunction(w, 'featsCompute',    @featsComputePassThrough);      fc{end+1}='pass-through';
        for(ksr = [0.1 0.3 0.7 1 2 3 5])
            w=addFunction(w, 'featsCompute',    @featsComputePCAWithKSR, ksr);     fc{end+1}=sprintf('PCA with ksr=%.2f', ksr);
        endfor;
        %this might go obsolete in the future.... or nope :) let's just code expert knowledge to exclude PCA and such
        w=addFunction(w, 'featsSelect',     @featsSelectPassThrough);          fs{end+1}='pass-through';
    %   w=addFunction(w, 'featsSelect',     @featsSelectKrusienski, w.p3session);            fs{end+1}='pass-through';
        
        for(corrthreshold=[0.001, 0.005, 0.01, 0.05, 0.1, 0.25])
            w=addFunction(w, 'featsSelect', @featsSelectFss, corrthreshold); fs{end+1}=sprintf('correlation based (coeff=%.3f)', corrthreshold);
        endfor;
    else
        %w=addFunction(w, 'featsCompute',    @featsComputePassThrough);  fc{end+1}='pass-through';
        ksr=3;
        w=addFunction(w, 'featsCompute',    @featsComputePCAWithKSR, ksr);  fc{end+1}=sprintf('PCA w ksr=%.2f', ksr);
        w=addFunction(w, 'featsSelect',     @featsSelectPassThrough);   fs{end+1}='pass-through';

    %   w=addFunction(w, 'featsCompute',     @featsComputePassThrough);   fc{end+1}='pass-through';
    %   w=addFunction(w, 'featsSelect',     @featsSelectFss, 0.25); fs{end+1}='Correlation 0.25';
    endif;

    
    %LOGISTIC REGRESSIONs
    for(lambda = lambdas)
        %register several flavors of LogisticRegression
%          w=addFunction(w, 'trainTest', @ClassifierLogReg, 150, lambda); tt{end+1}=sprintf('LogReg (lambda=%.3f)',lambda);
    endfor;

    %LINEAR SVMs
    for(c=cvalues)
        %register several flavors of SVM
        MODE=struct();
        MODE.TYPE='SVM';
        MODE.hyperparameter.c_value=c;
        w=addFunction(w, 'trainTest', @ClassifierNan, MODE); tt{end+1}=sprintf('Linear SVM (c=%.3f)',c);
    endfor;

    %RADIAL BASIS (GAUSSIAN) KERNEL SVMs
    for(c=cvalues)
        for(gamma=gammas)
            MODE=struct();
            MODE.TYPE='RBF';
            MODE.hyperparameter.c_value=c;
            MODE.hyperparameter.gamma=gamma;
%              w=addFunction(w, 'trainTest', @ClassifierNan, MODE); tt{end+1}=sprintf('Gaussian kernel SVM (c=%.3f, gamma=%.3f)',c, gamma);
        endfor;
    endfor;

    %FLDAs
    for(gamma=gammas)
        MODE=struct();
        MODE.TYPE='FLDA';
        MODE.hyperparameter.gamma=gamma;
        w=addFunction(w, 'trainTest', @ClassifierNan, MODE); tt{end+1}=sprintf('%s (gamma=%.3f)', MODE.TYPE, gamma);
    endfor;

    %Neural Networks
    for(lambda=lambdas(3:end))
        for(hidden_neurons = hidden_neurons_values)
            for(max_iterations = max_iterations_values)
%              w=addFunction(w, 'trainTest', @ClassifierNN, hidden_neurons, max_iterations, lambda ); tt{end+1}=sprintf('FFNN (lambda=%.3f, max iter=%d, hidden neurons=%d)', lambda, max_iterations, hidden_neurons);
            endfor;
        endfor;
    endfor;


    printf('launching workflow...'); fflush(stdout);
    summary=launch(w, fc, fs, tt, title);

    summarize(summary, fc, fs, tt);
    %summary should return the best setup. or sort everything according to (recall+presision)
    
endfunction;