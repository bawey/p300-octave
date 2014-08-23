%a P3Session object 'constructor' fror Berlin BCI Competition 3
function p3 = P3SessionBerlin(filePath)
    eeg=[]; stimuli=[]; targets=[]; channelsCount=64; samplingRate=240;
    channelNames={ 'FC5','FC3','FC1','FCZ','FC2','FC4','FC6', 'C5', 'C3', 'C1', 'CZ', 'C2', 'C4', 'C6', 'CP5', 'CP3', 'CP1', 'CPZ', 'CP2', 'CP4', 'CP6', 'Fp1', 'FpZ', 'Fp2', 'AF7', 'AF3', 'AFZ', 'AF4', 'AF8', 'F7', 'F5', 'F3', 'F1', 'FZ', 'F2', 'F4', 'F6', 'F8', 'FT7', 'FT8', 'T7', 'T8', 'T9', 'T10', 'TP7', 'TP8', 'P7', 'P5', 'P3', 'P1', 'PZ', 'P2', 'P4', 'P6', 'P8', 'PO7', 'PO3', 'POZ', 'PO4', 'PO8', 'O1', 'OZ', 'O2', 'IZ' };
    
    fprintf('loading data from %s ... ', filePath);
    load(filePath);
    fprintf('done \n');
    
    %need 'only' eeg, stimuli and targets
    
    epoch_length=192;
    
    for(periodNo=1:size(Signal,1))
        flash_onsets=Flashing(periodNo,:)-[0,Flashing(periodNo,1:end-1)]==1;
        
        stimuli=[stimuli; StimulusCode(periodNo, flash_onsets)'];
        
        onset_idx=find(flash_onsets==1);
        %transposing as using this value as index will process it column by column
        onset_mask=vec(linspace(onset_idx', onset_idx'+epoch_length-1, epoch_length)')';
        fflush(stdout);
        
        
        periodBlock=repmat(NaN, 180, epoch_length*channelsCount);
%          fprintf('epoch_length: %d, channelsCount: %d \n', epoch_length, channelsCount); fflush(stdout);
        for(channelNo=1:channelsCount)
            periodBlock(:,[1:epoch_length].+(channelNo-1)*epoch_length)=reshape(Signal(periodNo, onset_mask, channelNo), epoch_length, 180)';
        endfor;
        
        eeg=[eeg; periodBlock];
        
        if(exist('TargetChar'))
            [row, minuscolumn]=charCoords(TargetChar(periodNo));
            targets=[targets; row, minuscolumn];
        else
            targets=[targets; zeros(1,2)];
        endif;
        
    endfor;
    
    %it's still coded the original way... recoding
    stimuli(stimuli<7).*=-1;
    stimuli(stimuli>6).-=6;
    
    p3 = P3Session(eeg, stimuli, targets, channelsCount, samplingRate, channelNames);
    
endfunction;