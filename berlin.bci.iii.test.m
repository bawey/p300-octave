berlin3_data_path='~/Copy/eeg/berlin.bci.iii'

init();

files={'Subject_A_Train.mat', 'Subject_A_Test.mat', 'Subject_B_Train.mat', 'Subject_B_Test.mat'};

%try loading
p3ta=P3SessionBerlin3(sprintf('%s/%s', berlin3_data_path, files{3}));
p3ea=P3SessionBerlin3(sprintf('%s/%s', berlin3_data_path, files{4}));
%  p3tb=P3SessionBerlin3(sprintf('%s/%s', berlin3_data_path, files{3}));
%  p3eb=P3SessionBerlin3(sprintf('%s/%s', berlin3_data_path, files{4}));


expectedStringA='WQXPLZCOMRKO97YFZDEZ1DPI9NNVGRQDJCUVRMEUOOOJD2UFYPOO6J7LDGYEGOA5VHNEHBTXOO1TDOILUEE5BFAEEXAW_K4R3MRU';
expectedString='MERMIROOMUHJPXJOHUVLEORZP3GLOO7AUFDKEFTWEOOALZOP9ROCGZET1Y19EWX65QUYU7NAK_4YCJDVDNGQXODBEV2B5EFDIDNR';

printf('merging epochs...'); fflush(stdout); 
p3ta=groupEpochs(p3ta);
p3ea=groupEpochs(p3ea);

printf('downsampling...'); fflush(stdout);
p3ta=downsample(p3ta, 6);
p3ea=downsample(p3ea, 6);

[feats, labels, stimuli] = classificationData(p3ta, [1:p3ta.channelsCount], [1:p3ta.periodsCount]);
logreg = ClassifierLogReg(feats, labels);


chars={};
correct=0;

for(testperiod=1:p3ea.periodsCount)
    [feats, labels, stimuli] = classificationData(p3ea, [1:p3ea.channelsCount], [testperiod]);
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

fprintf('%6.2f correct\n',correct*100/length(expectedString));
