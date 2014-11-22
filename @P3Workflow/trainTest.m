%the ultimate element of the workflow: use the data to train a classifier and report on its performance
function [H, IH, correctSymbols, cse, csme]=trainTest(workflow, methodIdx, tfeats, tlabels, vfeats, vlabels, vstimuli, epochsPerPeriod)
	
	%mix the data a bit
	mixing_vec = randperm(length(tlabels));
	tlabels=tlabels(mixing_vec,:);
	tfeats=tfeats(mixing_vec, :);
	
	functionStruct=workflow.functions.trainTest{methodIdx};
	
	classifier = feval(functionStruct.functionHandle, tfeats, tlabels, functionStruct.arguments{:});
	
	p=probs=[];
	ap=[];
	
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
    	p=[p; periodPreds];

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
        ap=[ap; periodClassifierDecisions];
        
        % Would a character be classified correctly? If so, an aware method should pick the right row and the right column for each period considered.
    
        if(sum(periodClassifierDecisions==periodLabels)==length(periodLabels))
            ++correctSymbols;
        endif;
    endfor;
        
	H=zeros(2,2); IH=zeros(2,2);
	
	H(1,1)=sum( vlabels==0 & p==0 );
    H(1,2)=sum( vlabels==0 & p==1 );
    H(2,1)=sum( vlabels==1 & p==0 );
    H(2,2)=sum( vlabels==1 & p==1 );
    
    IH(1,1)=sum( vlabels==0 & ap==0 );
    IH(1,2)=sum( vlabels==0 & ap==1 );
    IH(2,1)=sum( vlabels==1 & ap==0 );
    IH(2,2)=sum( vlabels==1 & ap==1 );

    cse=sum((vlabels.-probs).^2);
	
endfunction;
