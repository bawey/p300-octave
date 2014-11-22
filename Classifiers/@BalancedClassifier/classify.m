%could be useful to make a character-wise prediction...
%is this one invoked always period-by-period? otherwise character wise prediction makes little sense
function [pred, prob] = classify(model, X, vstimuli)
	pred = prob = zeros(rows(vstimuli),1);
	for(i=1:length(model.units))
        [nevermind, subprob] = classify(model.units{i}, X);
		
		% ordinary probabilities summing - old method
		prob=prob+subprob;
		
		% get units to vote! assuming the classifier is only asked about one period at a time
		[response, row, col, labelodds] = periodCharacterPrediction(vstimuli, subprob);
		[confr, confc] = labeloddsConfidence(labelodds);
		
		subpred = (confr*(vstimuli==row) | confc*(vstimuli==-abs(col)));
		pred=pred+subpred;
%  		fprintf('min max of subprob: %.3f and %.3f\n', min(subprob), max(subprob));
	endfor;
	
	prob./=length(model.units);
	%should be aware prediction anyway
	pred./=length(model.units);
	
	% comment out\in to switch between averaging continuous response and discrete decisions
%    	prob=pred
	% and to see the difference between the two
%  	[pred, prob]

    %former method, based on probabilities averaging
	%pred=prob>0.5;
	
	%voting! ties should also be handled :(
	prob=pred;

endfunction;