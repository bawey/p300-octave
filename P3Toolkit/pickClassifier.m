function [model, tr_mean, tr_std, modelCell] = pickClassifier(session)
    splitRate = factor(session.periodsCount)(1);
    fprintf('using a session of %d characters and %d-fold cross-validation to estimate fitness of models \n', session.periodsCount, splitRate);
    % SplitCell does NOT include the samples number as this is later inserted automatically in P3Workflow...
    wf=P3WorkflowClassifierGridSearch(session, {@trainTestSplitMx, splitRate}, 'fast');
    summary = launch(wf);
    %will dump the results to console
    modelCell = getBest(summary).trainTest;

    summarize(summary);
%now we can train our model of choice on the whole available dataset
%      printf('modelCell{1} \n');
%      modelCell{1}
%      printf('modelCell{2} \n');
%      modelCell{2}

    

    [model, tr_mean, tr_std] = trainClassifier(modelCell{1}, modelCell{2}, session);
    
endfunction;