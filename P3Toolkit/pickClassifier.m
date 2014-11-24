% function [model modelCell featsSelectCell summary] = pickClassifier(session, classification_methods='all')
function [model modelCell featsSelectCell summary] = pickClassifier(session, classification_methods='all')
    
    % train session epochs will be split in <smallest factor> number of periods to increase the depth of classifier comparison
    session = P3SessionSplitRepeats(session, 'min');
    
    % xvalidation split rate will be the smallest factor to cut down processing time
    splitRate = factor(session.periodsCount)(1);  
    fprintf('using a session of %d characters and %d-fold cross-validation to estimate fitness of models \n', session.periodsCount, splitRate);
    
    
    % SplitCell does NOT include the samples number as this is later inserted automatically in P3Workflow...
    wf=P3WorkflowClassifierGridSearch(session, {@trainTestSplitMx, splitRate}, classification_methods);
    summary = launch(wf);
    %will dump the results to console

    modelCell = getBest(summary).trainTest;
    featsSelectCell = getBest(summary).featsSelect;
    featsComputeCell = getBest(summary).featsCompute;
    

%      summarize(summary);
%now we can train our model of choice on the whole available dataset
%      printf('modelCell{1} \n');
%      modelCell{1}
%      printf('modelCell{2} \n');
%      modelCell{2}

       
    % Classifier and its traindata-dependent parameters
    [model] = trainClassifier(session, modelCell, featsSelectCell, featsComputeCell);
    
    
endfunction;