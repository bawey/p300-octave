function [pred, prob] = classify(model, X)
	[pred, prob]= classify(model.units{1}, X);
	for(i=2:length(model.units))
		[subpred, subprob]=classify(model.units{i}, X);
		prob=prob+subprob;
		pred=pred+subpred;
	endfor;
	prob./=length(model.units);
	%should be aware prediction anyway
	pred./=length(model.units);
	
	% comment out\in to switch between averaging continuous response and discrete decisions
	%prob=pred;
	% and to see the difference between the two
	%[pred, prob]

	pred=prob>0.5;

endfunction;