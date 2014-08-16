%method yields a new P3Session instance with the signal filtered acording to b a
function p3filtered=filterEeg(p3original, b, a)
	p3filtered=p3original;
	
	for(sampleNo=1:size(p3filtered.signal,1))
		for(channelNo=1:p3filtered.channelsCount)
			channelMask=[1:p3filtered.samplesCountPerEpoch]+(channelNo-1)*p3filtered.samplesCountPerEpoch;
			p3filtered.signal(sampleNo, channelMask)=filter(b,a,p3filtered.signal(sampleNo, channelMask));
		endfor;
	endfor;
endfunction;