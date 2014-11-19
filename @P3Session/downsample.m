function p3d=downsample(p3s, factor)
	copysignal=p3s.signal;
	tempsignal=zeros(rows(copysignal), columns(copysignal)/factor);
	size(tempsignal)
	target_columns_per_channel=ceil(columns(tempsignal)/p3s.channelsCount);
	for(i=1:size(p3s.signal,1))
%  		tempperiod=zeros(1, size(tempsignal, 2));
		for(j=1:p3s.channelsCount)
            %tempperiod(1, [1:target_columns_per_channel]+target_columns_per_channel*(j-1))=[decimate(copysignal(i,channelColumnsSelector(p3s, j)), factor)];
            tempsignal(i, [1:target_columns_per_channel]+target_columns_per_channel*(j-1))=[decimate(copysignal(i,channelColumnsSelector(p3s, j)), factor)];
		endfor;
%  		tempsignal(i, :)=tempperiod;
%          if(rand()>0.95)
%              printf('progress %.2f%% \r', i/size(p3s.signal,1)*100); fflush(stdout);
%          endif;
	endfor;
	size(tempsignal)
	p3d=P3Session(tempsignal, p3s.stimuli, p3s.targets, p3s.channelsCount, p3s.samplingRate/factor, p3s.channelNames);
endfunction;