%the ultimate element of the workflow: use the data to train a classifier and report on its performance
function [H, IH]=trainTest(workflow, methodIdx, tfeats, tlabels, vfeats, vlabels)
	functionStruct=workflow.functions.trainTest{methodIdx};
	[H, IH]=feval(functionStruct.functionHandle, tfeats, tlabels, vfeats, vlabels, functionStruct.arguments{:});
endfunction;