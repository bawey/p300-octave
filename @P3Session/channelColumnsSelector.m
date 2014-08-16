%merely a helper for extracting correct ranges of samples with respect to channel
function selector = channelColumnsSelector(p3, channelNo)
	selector = ([1:p3.samplesCountPerEpoch] + p3.samplesCountPerEpoch*(channelNo-1));
endfunction;