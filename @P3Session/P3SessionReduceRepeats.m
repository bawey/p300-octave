% function p3r = P3SessionReduceRepeats(p3, reduceby=1)
function p3r = P3SessionReduceRepeats(p3, reduceby=1)
    signal = p3.signal;
    stimuli = p3.stimuli;
    
    % Will hold indices of epochs to trim
    idx=zeros(rows(p3.signal), 1);

    pc=p3.periodsCount;
    eps=p3.epochsCountPerStimulus;
    epp=p3.epochsCountPerPeriod;
    
    % Basic formula for trimming a single period by 1 is:
    %   start at (epochsPerStimulus-1)/epochsPerStimulus * epochsPerPeriod +1
    %   end at the end of the period: epochsPerPeriod
    
    for(period=1:pc)
        idx( (((eps-reduceby)/eps * epp +1) : epp) + (period-1)*epp ) = 1;
    endfor;

%      size(signal)
    signal(idx==1,:)=[];
%      size(signal)
%      size(stimuli)
    stimuli(idx==1)=[];
%      size(stimuli)
    
    p3r = P3Session(signal, stimuli, p3.targets, p3.channelsCount, p3.samplingRate, p3.channelNames);
endfunction;