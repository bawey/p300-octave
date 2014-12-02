%the ultimate element of the workflow: use the data to train a classifier and report on its performance
% Returns:
%   H:  confusion matrix
%   IH: aware (informed) confusion matrix
%
%
%   fewestSufficientRepeats: a vector of repeats (epochs per stimuli) needed to make the correct decision (or max if decision is wrong)
%   totalConf: returns accumulated confidence for correct predictions
%   totalOverconf: accumulated overconfidence, confidence of wrong predictions
function [H, IH, correctSymbols, cse, csme, microScore, totalConf, totalOverconf, cste]=trainTest(workflow, methodIdx, tfeats, tlabels, vfeats, vlabels, vstimuli, epochsPerPeriod)
	
	microScore = 0;
	dominanceRatio = sum(tlabels==0)/sum(tlabels==1);
	
	fewestSufficientRepeats=[];
	totalConf=0;
	totalOverconf=0;
	
	%mix the data a bit
	mixing_vec = randperm(length(tlabels));
	tlabels=tlabels(mixing_vec,:);
	tfeats=tfeats(mixing_vec, :);
	
	functionStruct=workflow.functions.trainTest{methodIdx};
	
	% nocentering instructs the classifier that the centering is handled outside, which is the case here - for performance sake
	classifier = feval(functionStruct.functionHandle, tfeats, tlabels, functionStruct.arguments{:}, [], 'nocentering');
	
	predictions=[];
	probs=[];
	aware_predictions=[];
	
	correctSymbols=0;
    %cumulative square mean error: first average within each epoch, then sqare the [avg(stimuli)-label] value
    csme=0;
	%we need to know how long a period is
	
	% ITERATE OVER ALL CLASSIFIED PERIODS
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
        
        % have a look at labelodds to determine confidence
        [confr, confc]=labeloddsConfidence(labelodds);
        conf = 2*confr*confc/(confr+confc);
        
        periodClassifierDecisions=(periodStimuli==row | periodStimuli == col);
        aware_predictions=[aware_predictions; periodClassifierDecisions];
        
        % Would a character be classified correctly? If so, an aware method should pick the right row and the right column for each period considered.
        
        epochsPerStimulus = epochsPerPeriod/numel(unique(periodStimuli));
        epochsRequiredForThisPeriod = epochsPerStimulus;
        
        if(sum(periodClassifierDecisions==periodLabels)==length(periodLabels))
            ++correctSymbols;
            totalConf+=conf;
            % if the symbol was correct, let's also indicate how many periods were sufficient to make the decision - a mock version (start from 4, less is very unlikely).
        else
            totalOverconf+=conf;
        endif;
        
        periodAnswers=unique(periodStimuli(periodLabels));
        assert(numel(periodAnswers)==2);

        
%            printf('going from: ');
            for(eps=1:epochsPerStimulus)
                sectionStart    =   rows(periodStimuli)*(eps-1)/epochsPerStimulus  +  1;
                sectionEnd      =   rows(periodStimuli)*eps/epochsPerStimulus;
%                    printf(' %d to %d ', sectionStart, sectionEnd);
                fewerStimuli    =   periodStimuli(sectionStart:sectionEnd, :);
                fewerFeats      =   periodFeats(sectionStart:sectionEnd, :);
                fewerLabels     =   periodLabels(sectionStart:sectionEnd);
                
                [fewerPreds, fewerProbs]    =   classify(classifier, fewerFeats, fewerStimuli);
                [fewerResponse, fewerRow, fewerCol, fewerLabelodds] = periodCharacterPrediction(fewerStimuli, fewerProbs);              
                subScore = (fewerCol==periodAnswers(1)) + (fewerRow==periodAnswers(2));
                microScore += subScore;
                
                probVsReality=[fewerLabelodds(:,2), ismember(fewerLabelodds(:,1), periodPositiveStimuli)];
                assert(sum(probVsReality(:,2))==2);
        
                csmerrors=(probVsReality(:,1).-probVsReality(:,2)).^2;
                % minority group errors should get multiplied by dominance ratio
                csmerrors(probVsReality(:,2)==1).*=dominanceRatio;
                csme+=sum(csmerrors);
%                    printf('(%0.2f, %0.2f)', subScore, sum(csmerrors));
                
            endfor;
%                printf('\n');
%                fflush(stdout);
        
        
        
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


    se = (vlabels.-probs).^2;
    se(vlabels==1).*=dominanceRatio;
    cse=sum(se);
    
    ste = (vlabels.-predictions).^2;
    ste(vlabels==1).*=dominanceRatio;
    cste=sum(ste);
    
    assert(sum(H(:))==sum(IH(:)));
	
endfunction;
