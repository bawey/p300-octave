%method yields a new P3Session instance with the signal filtered acording to b a
function p3f=filterEeg(p3original, b, a)
	p3f=p3original;
	
	for(periodNo=1:p3f.periodsCount)
		epochsMask=[1:p3f.epochsCountPerPeriod].+ p3f.epochsCountPerPeriod*(periodNo-1);
		for(channelNo=1:p3f.channelsCount)
			channelMask=channelColumnsSelector(p3f,channelNo);
			tmp=vec(p3f.signal(epochsMask, channelMask)');
			tmp=filter(b,a,tmp);
			p3f.signal(epochsMask, channelMask)=reshape(tmp, p3f.samplesCountPerEpoch, p3f.epochsCountPerPeriod)';
		endfor;
	endfor;

endfunction;