%% takes as arguments raw matrices as read straight from files or passed from memory
%% performs signal re-folding to create feature vectors for each flash
%% function session = P3SessionLobeRaw(signalData, stimuliMeta, targets, channelsCount, samplingRate, channelNames)
function session = P3SessionLobeRaw(data, meta, targets, channelsCount, samplingRate, channelNames)

    epoch_length = 120;
    %Decimation Factor
    df=6;
    
    %Experimental piece!
    
    cputimestart=cputime;
    if(df>1)
        newsignal=[];
        epoch_length=epoch_length/df;
        for(column=2:columns(data))
            newsignal=[newsignal, decimate(data(:,column), df)];
        endfor;
        newsignal=[ linspace(data(1,1), data(end,1), rows(newsignal))' , newsignal];
        data=newsignal;
    endif;
    decimationTime = cputime - cputimestart;
    printf('Decimation took %.3f seconds\n', decimationTime);
    
    samples=size(meta,1);
    channels = size(data,2)-1;
    
    signal=repmat(NaN, rows(meta), channels*epoch_length);
    stimuli=meta(:,3);
    targets=targets(:,2:end);
    
    for(sampleNo=1:samples)
        onset = meta(sampleNo, 1);
        %look in data for timestamps greater than current onset timestamp and take only the first 'epoch_length' of such
        timemarks = data(data(:,1)>onset,1)(1:epoch_length);
        for(channelNo=1:channels)
            signal(sampleNo, ((channelNo-1)*epoch_length+1) : (channelNo*epoch_length) ) = data((data(:,1)>=timemarks(1) & data(:,1)<=timemarks(end)), channelNo+1)';
        endfor;
    endfor;
    assert(sum(isnan(signal)(:))==0);
    session=P3Session(signal, stimuli, targets, channelsCount, samplingRate/df, channelNames);

endfunction;