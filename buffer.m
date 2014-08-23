%this file assumes
init();

[feats, labels, stimuli] = classificationData(p3train, [1:p3train.channelsCount], [1:p3train.periodsCount]);
[feats, tr_mean, tr_std] = centerTrainData(feats);

classifier = ClassifierNN(feats, labels, 40, 50, 2);



chars={};
correct=0;

for(testperiod=1:p3test.periodsCount)
    [feats, labels, stimuli] = classificationData(p3test, [1:p3test.channelsCount], [testperiod]);
    feats=centerTestData(feats, tr_mean, tr_std);
    [labels, prob]=classify(classifier, feats);
    
    aware_labels=sextetWiseAwarePrediction(prob);
    
    row=stimuli(stimuli>0 & aware_labels==1);
    column=stimuli(stimuli<0 & aware_labels==1);
    
    chars{end+1}=characterAt(row, column);
    fprintf('Character %2d: %s, expected %s \n',testperiod, chars{end}, teststring(testperiod));
    if(chars{end}==teststring(testperiod))
        ++correct;
    endif;

endfor;

fprintf('%6.2f%% correct\n', correct*100/length(teststring));
