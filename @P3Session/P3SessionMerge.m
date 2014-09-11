function p3session = P3SessionMerge(p3a, p3b)
    assert(p3a.channelsCount==p3b.channelsCount);
    assert(p3a.samplingRate==p3b.samplingRate);

    p3session=P3Session(
            [p3a.signal; p3b.signal], 
            [p3a.stimuli; p3b.stimuli], 
            [p3a.targets; p3b.targets], 
            p3a.channelsCount, p3a.samplingRate, p3a.channelNames);
endfunction;

