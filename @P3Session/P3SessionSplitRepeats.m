% Splits periods into periods with lower number of repetitions
% 
% function p3s = P3SessionSplitRepeats(session, mode='min')
% arg: split_ratio determines how many output periods will be produced from each original one
%   split_ratio can either be 'max' to yield max(factor(epochsCountPerPeriod)) periods or 'min'
function p3s = P3SessionSplitRepeats(session, split_ratio='min')
    factor = min(factor(session.epochsCountPerPeriod));
    if(strcmp(split_ratio,'max'))
        factor = max(factor(session.epochsCountPerStimulus));
    endif;
    newtargets=[];
    
    oldtargets=session.targets;
    
    for(trg=1:session.periodsCount)
        newtargets = [newtargets; repmat(oldtargets(trg,:),factor, 1)];
    endfor;
    
    p3s = P3Session(session.signal, session.stimuli, newtargets, session.channelsCount, session.samplingRate, session.channelNames);
    
endfunction;