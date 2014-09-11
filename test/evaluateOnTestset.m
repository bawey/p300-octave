function somesummary = evaluateOnTestset(p3train, p3test, teststring)
    p3m=P3SessionMerge(p3train, P3SessionAddLabels(p3test, teststring));
    
    flow=P3WorkflowClassifierGridSearch(p3m, {@trainTestSplitMerged, p3train.periodsCount});
    
    somesummary=launch(flow);

    summarize(somesummary);
    
endfunction;