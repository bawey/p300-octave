% IMPORTANT: This one has to be invoked period-by-period sd it relies on aware prediction for unit classifiers voting
% function [naive_label, scores] = classify(model, X, stimuli)
function [naive_label, scores] = classify(model, X, stimuli)
	
	if(model.centering == true)
        X=centerTestData(X, model.tr_mean, model.tr_std);
    endif;
    
	naive_label = scores = zeros(rows(stimuli),1);
	for(i=1:length(model.units))
        % we will care about the scores (similiar to scoresabilities) returned by unit classifiers
        [discard, u_scores] = classify(model.units{i}, X);
        if(model.voting==true)
            % scores are used to determine the most likely column\row and their confidence values
            [response, row, col, labelodds] = periodCharacterPrediction(stimuli, u_scores);
            [confr, confc] = labeloddsConfidence(labelodds);
            
            % each unit 'votes' for one row and one column, with the confidence used as a weight of a vote
            votes = (confr*(stimuli==row) | confc*(stimuli==-abs(col)));
            scores=votes+scores;
        else
            scores=u_scores+scores;
        endif;
	endfor;
	
	scores./=length(model.units);
	naive_label = scores>=0.5;

endfunction;