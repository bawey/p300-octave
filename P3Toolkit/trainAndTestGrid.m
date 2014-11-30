% function summary = trainAndTestGrid(p3train, p3test, classifiers='fast', balancing='no')
%   
%   Takes the p3train as the trainset to train all the methods on and p3test as the validation set
%   Produces a summary of performance on the p3test set
%
%   To use with standard Berlin set (no labels), add the labels into the test set by: P3SessionAddLabels(p3test, teststring)
%
%   classifiers and balancing parameters are relayed to P3WorkflowClassifierGridSearch

function somesummary = trainAndTestGrid(p3train, p3test, classifiers='fast', balancing='no')
    p3m=P3SessionMerge(p3train, p3test);
    w=P3WorkflowClassifierGridSearch(p3m, {@trainTestSplitMerged, p3train.periodsCount}, classifiers, balancing);

    somesummary = launch(w);
     
endfunction;
