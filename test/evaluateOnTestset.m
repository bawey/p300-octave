function somesummary = evaluateOnTestset(p3train, p3test, teststring)
    p3m=P3SessionMerge(p3train, P3SessionAddLabels(p3test, teststring));

    w=P3Workflow(p3m, {@trainTestSplitMerged, p3train.periodsCount});

    w=addFunction(w, 'featsCompute',    @featsComputePassThrough);
    w=addFunction(w, 'featsSelect',     @featsSelectPassThrough);    

%      w=addFunction(w, 'trainTest', @ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',1)));
      w=addFunction(w, 'trainTest', @ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',0.1)));
%      w=addFunction(w, 'trainTest', @ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',0.01)));
    
%        w=addFunction(w, 'trainTest', @ClassifierNan, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',.1)));
      w=addFunction(w, 'trainTest', @ClassifierNan, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',1)));
%      w=addFunction(w, 'trainTest', @ClassifierNan, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',.05)));
    
      w=addFunction(w, 'trainTest', @ClassifierLogReg, 100, 10);
      w=addFunction(w, 'trainTest', @ClassifierLogReg, 100, 1);
      w=addFunction(w, 'trainTest', @ClassifierLogReg, 100, 0.1);
    
%    w=addFunction(w, 'trainTest', @ClassifierNN, 48, 100, 1);
     w=addFunction(w, 'trainTest', @ClassifierNN, 32, 100, 10);
%    w=addFunction(w, 'trainTest', @ClassifierNN, 64, 100, 100);
    
    somesummary=launch(w);

    summarize(somesummary);
    
endfunction;