%the ultimate element of the workflow: use the data to train a classifier and report on its performance
function [H, IH]=trainTest(workflow, methodIdx, tfeats, tlabels, vfeats, vlabels)
	functionStruct=workflow.functions.trainTest{methodIdx};
	
	classifier = feval(functionStruct.functionHandle, tfeats, tlabels, functionStruct.arguments{:});
	
	[p, prob]=classify(classifier, vfeats);
	ap=sextetWiseAwarePrediction(prob);
	pause;
	
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