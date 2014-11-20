function results = askClassifier(classifier, p3session, tr_mean, tr_std)
    results=[];
    for(periodNo=1:p3session.periodsCount)
        [feats, labels, stimuli] = classificationData(p3session, [1:p3session.channelsCount], [periodNo]);
        %labels may well be empty here! this one is for online predictions mainly!
        feats=centerTestData(feats, tr_mean, tr_std);
        [preds probs] = classify(classifier, feats);
        [sign row column labelodds] = periodCharacterPrediction(stimuli, probs);
            
        [confr, confc]=labeloddsConfidence(labelodds);
        harmconf = confr*confc/(confr+confc);
        
        printf('period %d:     %d. row (conf %.3f), %d. column (conf %.3f). Seems like character %s (harm conf %.3f) \n', periodNo, row, confr, column, confc, sign, harmconf);
        results=[results; row, column];
    endfor;
endfunction;