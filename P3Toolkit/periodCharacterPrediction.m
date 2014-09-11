% function response = periodCharacterPrediction(stimuli, probs)
% example:
%   stimuli = [-6 -5 -4 -6 -3 -5 1 3 4 1 3]';
%   probs = [0.1 0.2 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.5]';
%   response = periodCharacterPrediction(stimuli, probs)
%   should yield the character at (3, -5)
%
%
%
function [response, row, col, odds] = periodCharacterPrediction(stimuli, probs)
    labels = unique(stimuli);
    
    %odds will store label - avg(prob) for that label
    odds=[labels, zeros(size(labels))];

    for(label = vec(labels)') 
        odds(odds(:,1)==label,2)=mean(probs(stimuli==label));
    endfor;

    
    
    [val, order] = sort(odds(:,2),'descend');
    
    %these will usually be 1 and 2, but sometimes 2 columns (rows) might seem more likely for classifier 
    row =  labels(order)(min(find(odds(order,1)>0)));
    col =  labels(order)(min(find(odds(order,1)<0)));
    
    response=characterAt(row, col);
    
endfunction;