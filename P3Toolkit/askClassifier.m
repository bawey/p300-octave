% function results = askClassifier(classifier, p3session, tr_mean, tr_std, featsIdx)
%   classifier  - trained classifier object
%   p3session   - data to classify
function [results, confidence] = askClassifier(classifier, p3session)
    results=[];
    confidence=[];
    for(periodNo=1:p3session.periodsCount)
        % labels may well be empty here! this one is for online predictions mainly!
        [feats, labels, stimuli] = classificationData(p3session, [1:p3session.channelsCount], [periodNo]);

        [preds probs] = classify(classifier, feats, stimuli);
        [sign row column labelodds] = periodCharacterPrediction(stimuli, probs);
            
        [confr, confc]=labeloddsConfidence(labelodds);
%          harmconf = 2*confr*confc/(confr+confc);
        harmconf = min(confr, confc);
        
%          printf('period %d:     %d. row (conf %.3f), %d. column (conf %.3f). Seems like character %s (harm conf %.3f) \n', periodNo, row, confr, column, confc, sign, harmconf);
        results=[results; row, column];
        confidence=[confidence; harmconf];
    endfor;
endfunction;