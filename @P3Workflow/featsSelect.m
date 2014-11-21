% Based on the training data and its labels, determine the features worth preserving
% function featureIdx = featsSelect(workflow, methodIdx, tfeats, tlabels)
function featureIdx = featsSelect(workflow, methodIdx, tfeats, tlabels)
	functionStruct=workflow.functions.featsSelect{methodIdx};
	featureIdx=feval(functionStruct.functionHandle, tfeats, tlabels, functionStruct.arguments{:});
endfunction;