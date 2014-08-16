function channelIdx = channelIndex(p3, channelName)
	names=p3.channelNames;
	for(channelIdx=1:length(p3.channelNames))
		if(strcmp(names{channelIdx}, channelName)==1)
			return;
		endif;
	endfor;
	channelIdx=-1;
endfunction;