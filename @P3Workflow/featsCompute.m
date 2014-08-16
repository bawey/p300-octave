%This method examines training features and (potentially) their respective labels to determine how to transform
%the data. Having determined the parameters of transformation, it is applied to validation data without knowing its labels
function [tfeats, vfeats] = featsCompute(workflow, methodIdx, tfeats, tlabels, vfeats)
	functionStruct=workflow.functions.featsCompute{methodIdx};
	[tfeats, vfeats]=feval(functionStruct.functionHandle, tfeats, tlabels, vfeats, functionStruct.arguments{:});
endfunction;