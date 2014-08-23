#! /usr/bin/octave

berlin_data_path='~/Copy/eeg/berlin.bci.ii/';

init();

expectedString=strcat('FOOD','MOOT','HAM','PIE','CAKE','TUNA','ZYGOT','4567');

train_files={};
test_files={};
for(i=1:8)
    test_files{end+1}=sprintf('%s/AAS012R%02d.mat', berlin_data_path, i);
    %here shour be 6, but AAS001R1106.mat contains some oddities. we'll train on less samples then
    if(i<=5)
        train_files{end+1}=sprintf('%s/AAS011R%02d.mat', berlin_data_path, i);
        if(i<=5)
            train_files{end+1}=sprintf('%s/AAS010R%02d.mat', berlin_data_path, i);
        endif;
    endif;
endfor;

%load the test data and training data
p3test=P3SessionBerlin(test_files{:});
p3train=P3SessionBerlin(train_files{:});

assert(p3test.periodsCount==length(expectedString));

printf('merging epochs...'); fflush(stdout); 
p3test=groupEpochs(p3test);
p3train=groupEpochs(p3train);

printf('downsampling...'); fflush(stdout);
p3test=downsample(p3test, 6);
p3train=downsample(p3train, 6);

[feats, labels, stimuli] = classificationData(p3train, [1:p3train.channelsCount], [1:p3train.periodsCount]);
logreg = ClassifierLogReg(feats, labels);


chars={};
correct=0;

for(testperiod=1:p3test.periodsCount)
    [feats, labels, stimuli] = classificationData(p3test, [1:p3test.channelsCount], [testperiod]);
    [labels, prob]=classify(logreg, feats);
    [prob, labels, stimuli];
    
    chances=[prob, stimuli];
    [value, indices] = sort(prob, 'descend');
    row=0;
    column=0;

    for(i=1:length(indices))
        idx=indices(i,1);
        if(stimuli(idx,1)<0 && column==0)
            column=stimuli(idx,1);
        endif;
        if(stimuli(idx,1)>0 && row==0)
            row=stimuli(idx,1);
        endif;
    endfor;

    chars{end+1}=characterAt(row, column);
    fprintf('Character %2d: %s, expected %s \n',testperiod, chars{end}, expectedString(testperiod));
    if(chars{end}==expectedString(testperiod))
        ++correct;
    endif;

endfor;

fprintf('%6.2f correct\n', correct*100/length(expectedString));



