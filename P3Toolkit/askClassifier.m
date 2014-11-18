function results = askClassifier(classifier, p3session, tr_mean, tr_std)
    results=[];
    for(periodNo=1:p3session.periodsCount)
        [feats, labels, stimuli] = classificationData(p3session, [1:p3session.channelsCount], [periodNo]);
        %labels may well be empty here! this one is for online predictions mainly!
        feats=centerTestData(feats, tr_mean, tr_std);
        [preds probs] = classify(classifier, feats);
        [sign row column labelodds] = periodCharacterPrediction(stimuli, probs);
        printf('period %d: %d. row, %d. column. Seems like character %s \n', periodNo, row, column, sign);
        results=[results; row, column];
    endfor;
endfunction;