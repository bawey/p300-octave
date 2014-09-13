function somesummary = evaluateOnTestset(p3train, p3test, teststring)
    p3m=P3SessionMerge(p3train, P3SessionAddLabels(p3test, teststring));

    w=P3Workflow(p3m, {@trainTestSplitMerged, p3train.periodsCount});

    w=addFunction(w, 'featsCompute',    @featsComputePassThrough);
    w=addFunction(w, 'featsSelect',     @featsSelectPassThrough);    

      w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',1))});
      w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',0.1))});
      w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',0.01))});
%      
      w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNan, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',.1))});
      w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNan, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',1))});
      w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNan, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',.05))});
    w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNan, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',.10))});
      w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNan, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',5))});
      w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNan, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',.005))});
       w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNan, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',.001))});
    
    
    w=addFunction(w, 'trainTest', @ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',1)));
    w=addFunction(w, 'trainTest', @ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',0.1)));
    w=addFunction(w, 'trainTest', @ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',0.01)));
    
    w=addFunction(w, 'trainTest', @ClassifierNan, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',.1)));
    w=addFunction(w, 'trainTest', @ClassifierNan, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',1)));
    w=addFunction(w, 'trainTest', @ClassifierNan, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',.05)));
    
    
     w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierLogReg, 100, 10});
     w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierLogReg, 100, 1});
     w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierLogReg, 100, 0.1});
    
     w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierLogReg, 100, 100});
     w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierLogReg, 100, 0.01});
     w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierLogReg, 100, 0.001});
    
     w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNN, 32, 100, 0.001});
     w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNN, 32, 100, 0.01});
     w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNN, 32, 100, 0.1});
     w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNN, 32, 100, 1});
     w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNN, 32, 100, 10});
     w=addFunction(w, 'trainTest', @BalancedClassifier, {@ClassifierNN, 32, 100, 100});
    
    somesummary=launch(w);

    summarize(somesummary);
    
endfunction;
