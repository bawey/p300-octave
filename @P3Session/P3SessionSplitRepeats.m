% Splits periods into periods with lower number of repetitions
% 
% function p3s = P3SessionSplitRepeats(session, mode='min/max/no(ne)')
% arg: split_ratio determines how many output periods will be produced from each original one
%   split_ratio can either be 'max' to yield max(factor(epochsCountPerPeriod)) periods or 'min'
function p3s = P3SessionSplitRepeats(session, split_ratio='min')
    
    thefactor=0;
  
    if(isstr(split_ratio) && (strcmp('no', split_ratio) || strcmp('none', split_ratio)))
        p3s = session;
    else
        if(isnumeric(split_ratio))
            thefactors  = allfactor(session.epochsCountPerStimulus);
            thefactor   = thefactors(find(thefactors>=split_ratio)(1));
        else
            factors = allfactor(session.epochsCountPerStimulus)(2:end);
            
            thefactor = factors(1);
            if(strcmp(split_ratio,'max'))
                thefactor = factors(end)
            endif;
        endif;
        
        newtargets=[];
        
        oldtargets=session.targets;
        
        for(trg=1:session.periodsCount)
            newtargets = [newtargets; repmat(oldtargets(trg,:),thefactor, 1)];
        endfor;
        
        p3s = P3Session(session.signal, session.stimuli, newtargets, session.channelsCount, session.samplingRate, session.channelNames);

    endif;
endfunction;