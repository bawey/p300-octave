function [model, tr_mean, tr_std] = pickClassifier(session)
    splitRate = factor(session.periodsCount)(1);
    fprintf('using a session of %d characters and %d-fold cross-validation to estimate fitness of models \n', session.periodsCount, splitRate);
    wf=P3WorkflowClassifierGridSearch(session, {@trainTestSplitMx, session.periodsCount, splitRate}, 'fast');
    summary = launch(wf);
    %will dump the results to console
    modelCell = getBest(summary).trainTest;

%      summarize(summary);
%now we can train our model of choice on the whole available dataset
%      printf('modelCell{1} \n');
%      modelCell{1}
%      printf('modelCell{2} \n');
%      modelCell{2}

    [model, tr_mean, tr_std] = trainClassifier(modelCell{1}, modelCell{2}, session);
endfunction;