%the ultimate element of the workflow: use the data to train a classifier and report on its performance
% Returns:
%   H:  confusion matrix
%   IH: aware (informed) confusion matrix
%
%
%   fewestSufficientRepeats: a vector of repeats (epochs per stimuli) needed to make the correct decision (or max if decision is wrong)
function [H, IH, correctSymbols, cse, csme, fewestSufficientRepeats]=trainTest(workflow, methodIdx, tfeats, tlabels, vfeats, vlabels, vstimuli, epochsPerPeriod)
	
	fewestSufficientRepeats=[];
	
	%mix the data a bit
	mixing_vec = randperm(length(tlabels));
	tlabels=tlabels(mixing_vec,:);
	tfeats=tfeats(mixing_vec, :);
	
	functionStruct=workflow.functions.trainTest{methodIdx};
	
	classifier = feval(functionStruct.functionHandle, tfeats, tlabels, functionStruct.arguments{:});
	
	predictions=[];
	probs=[];
	aware_predictions=[];
	
	correctSymbols=0;
    %cumulative square mean error: first average within each epoch, then sqare the [avg(stimuli)-label] value
    csme=0;
	%we need to know how long a period is
	
	for(i=0:epochsPerPeriod:rows(vfeats)-1)
        periodStimuli=vstimuli(i+1:i+epochsPerPeriod,:);
    	periodLabels=vlabels(i+1:i+epochsPerPeriod,:);
    	periodFeats=vfeats(i+1:i+epochsPerPeriod,:);
    	[periodPreds, periodProbs]=classify(classifier, periodFeats, periodStimuli);
    	
    	probs=[probs; periodProbs];
    	predictions=[predictions; periodPreds];

    	periodLabelledStimuli=[periodLabels, periodStimuli];
    	periodPositiveStimuli=unique(periodStimuli(periodLabels==1, :));
    	
    	%need to square (avg(per_response_stimuli)-per_response_label), first let's get the labelodds

        [response, row, col, labelodds] = periodCharacterPrediction(periodStimuli, periodProbs);
        
        %use dbstop(func, line) to examine the outcome of the following:      
%        labelodds
        
        prob_reality=[labelodds(:,2), ismember(labelodds(:,1), periodPositiveStimuli)];
        
        csmerrors=(prob_reality(:,1).-prob_reality(:,2)).^2;
        csme+=sum(csmerrors);

        periodClassifierDecisions=(periodStimuli==row | periodStimuli == col);
        aware_predictions=[aware_predictions; periodClassifierDecisions];
        
        % Would a character be classified correctly? If so, an aware method should pick the right row and the right column for each period considered.
        
        epochsPerStimulus = epochsPerPeriod/numel(unique(periodStimuli));
        epochsRequiredForThisPeriod = epochsPerStimulus;
        highestRepeatsWrongAnswer = 0;
        if(sum(periodClassifierDecisions==periodLabels)==length(periodLabels))
            ++correctSymbols;
            % if the symbol was correct, let's also indicate how many periods were sufficient to make the decision - a mock version (start from 4, less is very unlikely).
            for(eps=1:epochsPerStimulus)
                sectionEnd = rows(periodStimuli)*eps/epochsPerStimulus;
                fewerStimuli    =   periodStimuli(1:sectionEnd, :);
                fewerFeats      =   periodFeats(1:sectionEnd, :);
                [fewerPreds, fewerProbs]=classify(classifier, fewerFeats, fewerStimuli);
                [fewerResponse, fewerRow, fewerCol, fewerLabelodds] = periodCharacterPrediction(fewerStimuli, fewerProbs);
                if(fewerCol==col && fewerRow==row)
                    if(epochsRequiredForThisPeriod==epochsPerStimulus)
                    %this is no longer used. what matters is the last wrong
                    epochsRequiredForThisPeriod = eps;
                    %   fprintf('so we found our minimum reps, using %d rows of simuli\n', size(fewerStimuli,1));                      
                    %   break;
                    endif;
                else
                        highestRepeatsWrongAnswer=eps;
                endif;
            endfor;
        else
            highestRepeatsWrongAnswer=epochsPerStimulus;
        endif;
        % fprintf('%d repeats were sufficient to tell the right character! Last error at %d repeats. Epochs per stimulus is: %d \n', epochsRequiredForThisPeriod, highestRepeatsWrongAnswer, epochsPerStimulus);
        % What matters is not the fewest epochs needed for good answer, but the fewest for a good answer that doesn't get changed with introduction of subsequent epochs
        % fewestSufficientRepeats=[fewestSufficientRepeats; epochsRequiredForThisPeriod];
        fewestSufficientRepeats=[fewestSufficientRepeats; highestRepeatsWrongAnswer];
    endfor;
        
	H=zeros(2,2); IH=zeros(2,2);
	
	H(1,1)=sum( vlabels==0 & predictions==0 );
    H(1,2)=sum( vlabels==0 & predictions==1 );
    H(2,1)=sum( vlabels==1 & predictions==0 );
    H(2,2)=sum( vlabels==1 & predictions==1 );
    
    IH(1,1)=sum( vlabels==0 & aware_predictions==0 );
    IH(1,2)=sum( vlabels==0 & aware_predictions==1 );
    IH(2,1)=sum( vlabels==1 & aware_predictions==0 );
    IH(2,2)=sum( vlabels==1 & aware_predictions==1 );

    cse=sum((vlabels.-probs).^2);
    
    assert(sum(H(:))==sum(IH(:)));
	
endfunction;
