%method yields a new P3Session instance with the signal filtered acording to b and a.
%Filtering takes place for each channel's response separately, hence it takes a while to complete
function p3f=filterEeg(p3original, b, a)
	p3f=p3original;

    signal=p3f.signal;

    for(periodNo=1:p3f.periodsCount)
        printf('period %d \r',periodNo); fflush(stdout);
        for(epochNo=1:p3f.epochsCountPerPeriod)
            for(channelNo=1:p3f.channelsCount)
                row_mask=(periodNo-1)*p3f.epochsCountPerPeriod+epochNo;
                col_mask=channelColumnsSelector(p3f, channelNo);
                
                signal(row_mask,col_mask)=filtfilt(b, a, signal(row_mask,col_mask));
            endfor;
        endfor;
    endfor;
    p3f.signal=signal;
    
endfunction;