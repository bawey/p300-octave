
%channels and periods are either binary selector vectors or vectors of values to select like [1,2,8]

function [feats, labels, stimuli] = classificationData(p3, channels, periods)
	if(length(channels)==p3.channelsCount && min(channels)==0 && max(channels)==1)
		%channels are aligned horizontally in signal matrix
		channels=reshape(channels, 1, p3.channelsCount);
	else
		temp=zeros(1, p3.channelsCount);
		if(max(channels(:))>p3.channelsCount)
			error('Requested channel number higher than should ever be')
		endif;
		temp(channels)=1; channels=temp;
	endif;
	
	%produce a (row) channel mask for the signal
	channels = reshape( repmat( channels, p3.samplesCountPerEpoch, 1 ), 1, p3.samplesCountPerEpoch*p3.channelsCount )>0;
	
	if(length(periods)==p3.periodsCount && min(periods)==0 && max(periods)==1)
		reshape(periods, p3.periodsCount, 1);
	else
		temp=zeros(p3.periodsCount, 1);
		if(max(periods(:))>p3.periodsCount)
			error('Requested period number higher than should ever be')
		endif;			
		temp(periods)=1; periods=temp;
	endif;
	
	%produce a (column) period mask for the signal
	periods=vec(repmat(periods, 1, p3.epochsCountPerPeriod)')>0;
	
	feats=p3.signal(periods, channels);
	labels=p3.labels(periods);
	stimuli=p3.stimuli(periods);
	
endfunction;