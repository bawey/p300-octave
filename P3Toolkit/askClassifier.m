% function results = askClassifier(classifier, p3session, tr_mean, tr_std, featsIdx)
%   classifier  - trained classifier object
%   p3session   - data to classify
%   tr_mean     - vector of means from classifier training
%   tr_std      - vector of std from classifier training
%   featsMask   - vector of feature indices as computed by feature selection method
function results = askClassifier(classifier, p3session, tr_mean, tr_std, featsMask)
    results=[];
    for(periodNo=1:p3session.periodsCount)
        % labels may well be empty here! this one is for online predictions mainly!
        [feats, labels, stimuli] = classificationData(p3session, [1:p3session.channelsCount], [periodNo]);

        % center the data using trainset's parameters (mean and std) [BEFORE discarding features as this is the order taken while training]
        feats=centerTestData(feats, tr_mean, tr_std);
        
        % filter out surplus features according to features mask
        feats=feats(:, featsMask);

        [preds probs] = classify(classifier, feats);
        [sign row column labelodds] = periodCharacterPrediction(stimuli, probs);
            
        [confr, confc]=labeloddsConfidence(labelodds);
        harmconf = confr*confc/(confr+confc);
        
        printf('period %d:     %d. row (conf %.3f), %d. column (conf %.3f). Seems like character %s (harm conf %.3f) \n', periodNo, row, confr, column, confc, sign, harmconf);
        results=[results; row, column];
    endfor;
endfunction;