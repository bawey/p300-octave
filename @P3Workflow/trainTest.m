%the ultimate element of the workflow: use the data to train a classifier and report on its performance
function [H, IH]=trainTest(workflow, methodIdx, tfeats, tlabels, vfeats, vlabels, vstimuli, epochsPerPeriod)
	functionStruct=workflow.functions.trainTest{methodIdx};
	
	classifier = feval(functionStruct.functionHandle, tfeats, tlabels, functionStruct.arguments{:});
	
	[p, probs]=classify(classifier, vfeats);
	ap=[];
	%ap=sextetWiseAwarePrediction(probs);
	
	%we need to know how long a period is
	
	for(i=0:epochsPerPeriod:rows(vfeats)-1)
        stimuliOfConcern=vstimuli(i+1:i+epochsPerPeriod,:);
        [response, row, col] = periodCharacterPrediction(stimuliOfConcern, probs(i+1:i+epochsPerPeriod));
        ap=[ap; (stimuliOfConcern==row | stimuliOfConcern == col)];
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
	
endfunction;