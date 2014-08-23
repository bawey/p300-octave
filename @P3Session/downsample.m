function p3d=downsample(p3s, factor)
	copysignal=p3s.signal;
	tempsignal=[];
	for(i=1:size(p3s.signal,1))
        printf('period %d / %d \r', i, size(p3s.signal,1)); fflush(stdout);
		tempperiod=[];
		for(j=1:p3s.channelsCount)
			tempperiod=[tempperiod, decimate(copysignal(i,channelColumnsSelector(p3s, j)), factor)];
		endfor;
		tempsignal=[tempsignal; tempperiod];
	endfor;
	p3d=P3Session(tempsignal, p3s.stimuli, p3s.targets, p3s.channelsCount, p3s.samplingRate/factor, p3s.channelNames);
endfunction;