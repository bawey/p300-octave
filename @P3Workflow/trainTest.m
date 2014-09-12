%the ultimate element of the workflow: use the data to train a classifier and report on its performance
function [H, IH, correctSymbols, cse, csme]=trainTest(workflow, methodIdx, tfeats, tlabels, vfeats, vlabels, vstimuli, epochsPerPeriod)
	
	periodsNo = length(tlabels)/epochsPerPeriod;
	idxToRemove=[];
	minors = find(tlabels==1);
    majors = find(tlabels~=1);
    minorsPerPeriod = length(minors)/periodsNo;
	%=============== TRIVIAL MAJORITY UNDERSAMPLING =====================
	for(i=0:epochsPerPeriod:length(tlabels)-1)
        periodMajors=majors(majors>i & majors<=(i+epochsPerPeriod));
        throwouts   =periodMajors(randperm(length(periodMajors))(1+minorsPerPeriod:end));
        idxToRemove=[idxToRemove; throwouts];
	endfor;
	rowselector=~ismember( [1:length(tlabels)], idxToRemove);
	
	tfeats=tfeats(rowselector, :);
	tlabels=tlabels(rowselector, :);
	
	
	%====================================================================
	
	
	
	functionStruct=workflow.functions.trainTest{methodIdx};
	
	classifier = feval(functionStruct.functionHandle, tfeats, tlabels, functionStruct.arguments{:});
	
	[p, probs]=classify(classifier, vfeats);
	ap=[];
	
	correctSymbols=0;
    %cumulative square mean error: first average within each epoch, then sqare the [avg(stimuli)-label] value
    csme=0;
	%we need to know how long a period is
	
	for(i=0:epochsPerPeriod:rows(vfeats)-1)
        stimuliOfConcern=vstimuli(i+1:i+epochsPerPeriod,:);
    	periodLabels=vlabels(i+1:i+epochsPerPeriod,:);
    	periodProbs=probs(i+1:i+epochsPerPeriod);
    	
    	periodLabelsStimuli=[periodLabels, stimuliOfConcern];
    	
    	periodPositiveStimuli=unique(stimuliOfConcern(periodLabels==1, :));
    	%need to square (avg(per_response_stimuli)-per_response_label), first let's get the odds

        [response, row, col, odds] = periodCharacterPrediction(stimuliOfConcern, periodProbs);
        %use dbstop(func, line) to examine the outcome of the following:
        
%        odds
        
        estims=[odds(:,2), ismember(odds(:,1), periodPositiveStimuli)];
        
        csmerrors=(estims(:,1).-estims(:,2)).^2;
        csme+=sum(csmerrors);

        periodClassifierDecisions=(stimuliOfConcern==row | stimuliOfConcern == col);
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