function [model, tr_mean, tr_std, modelCell, featsMask, featsSelectCell] = pickClassifier(session, classification_methods='all')
    
    splitRate = factor(session.periodsCount)(end);  
    fprintf('using a session of %d characters and %d-fold cross-validation to estimate fitness of models \n', session.periodsCount, splitRate);
    
    % SplitCell does NOT include the samples number as this is later inserted automatically in P3Workflow...
    wf=P3WorkflowClassifierGridSearch(session, {@trainTestSplitMx, splitRate}, classification_methods);
    summary = launch(wf);
    %will dump the results to console

    modelCell = getBest(summary).trainTest;
    featsSelectCell = getBest(summary).featsSelect;
    featsComputeCell = getBest(summary).featsCompute;
    

    summarize(summary);
%now we can train our model of choice on the whole available dataset
%      printf('modelCell{1} \n');
%      modelCell{1}
%      printf('modelCell{2} \n');
%      modelCell{2}

       
    % Classifier and its traindata-dependent parameters
    [model, tr_mean, tr_std, featsMask] = trainClassifier(session, modelCell, featsSelectCell, featsComputeCell);
    
    
endfunction;