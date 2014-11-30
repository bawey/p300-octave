% function [model modelCell featsSelectCell summary] = pickClassifier(session, classification_methods='all\fast\slow', repeats_split='no/min/max', balancing='yes/no/only', xsplit='min/max/total/str2double()')
% params:
%   - classification_methods: ALL / fast / slow / fastest
%   - repeats_split: no / min /max 
%   - balancing: no / yes / only
%   - xsplit: min / max / total / number - foldness of cross validation. if a number is given, the factors are multiplied until the result is >= number
function [model modelCell featsSelectCell summary] = pickClassifier(session, classification_methods='all', repeats_split='no', balancing='no', xsplit='min')

    if(strcmp(repeats_split,'no')==false && strcmp(repeats_split,'none')==false)
        % train session epochs will be split in <smallest factor> number of periods to increase the depth of classifier comparison
        session = P3SessionSplitRepeats(session, repeats_split);
    endif;
    
    % xvalidation split rate will be the smallest factor to cut down processing time
    splitRate = min(factor(session.periodsCount));  
    if(isstr(xsplit) && strcmp(xsplit, 'max'))
        splitRate = max(factor(session.periodsCount));
    elseif(isstr(xsplit) && strcmp(xsplit, 'total'))
        splitRate = session.periodsCount;
    else
        splitRate=1;
        splitThresh = 1;
        if(isnumeric(xsplit))
            splitThresh = xsplit;
        else
            splitThresh=str2double(xsplit);
        endif;
        
        for(f=allfactor(session.periodsCount));
            if(f>=splitThresh)
                splitRate=f;
                break;
            endif;
        endfor;
    endif;
    
    fprintf('pickClassifier: train session of %d characters, %d-fold x-validation. balancing=%s, classification_methods=%s \n', session.periodsCount, splitRate, balancing, classification_methods);
    
    
    % SplitCell does NOT include the samples number as this is later inserted automatically in P3Workflow...
    wf=P3WorkflowClassifierGridSearch(session, {@trainTestSplitMx, splitRate}, classification_methods, balancing);
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