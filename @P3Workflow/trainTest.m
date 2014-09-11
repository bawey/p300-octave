%the ultimate element of the workflow: use the data to train a classifier and report on its performance
function [H, IH, correctSymbols, cse]=trainTest(workflow, methodIdx, tfeats, tlabels, vfeats, vlabels, vstimuli, epochsPerPeriod)
	functionStruct=workflow.functions.trainTest{methodIdx};
	
	classifier = feval(functionStruct.functionHandle, tfeats, tlabels, functionStruct.arguments{:});
	
	[p, probs]=classify(classifier, vfeats);
	ap=[];
	correctSymbols=0;

	%we need to know how long a period is
	
	for(i=0:epochsPerPeriod:rows(vfeats)-1)
        stimuliOfConcern=vstimuli(i+1:i+epochsPerPeriod,:);
    	periodLabels=vlabels(i+1:i+epochsPerPeriod,:);

        [response, row, col] = periodCharacterPrediction(stimuliOfConcern, probs(i+1:i+epochsPerPeriod));
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

    cse=sum((vlabels.-probs).^2)
	
endfunction;