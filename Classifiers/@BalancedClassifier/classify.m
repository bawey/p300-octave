function [pred, prob] = classify(model, X)
	[subpred, prob]= classify(model.units{1}, X);
	for(i=2:length(model.units))
		[subpred, subprob]=classify(model.units{i}, X);
		prob=prob+subprob;
	endfor;
	prob./=length(model.units);
	pred=prob>0.5;
endfunction;