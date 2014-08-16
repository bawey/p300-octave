function plotPeriodChannelResponses(p3, channel, periodNo)
	channelNo=-1;
	if(isnumeric(channel))
		channelNo=channel;
	elseif(ischar(channel))
		channelNo=channelIndex(p3, channel);
	endif;
	[feats, labels, stimuli] = classificationData(p3, [channelNo], [periodNo]);
	
	printf('plotPeriodChannelResponses: got %d feature vectors, %d labels and %d stimuli\n', rows(feats), rows(labels), rows(stimuli));
	fflush(stdout);
	
	unique_stimuli = sort(unique(stimuli'));
	
	factored=factor(length(unique_stimuli));
	cols=prod(factored(ceil(end/2)+1:end));
	rows=prod(factored(1:ceil(end/2)));
	
	data_x=linspace(0, p3.samplesCountPerEpoch/p3.samplingRate, p3.samplesCountPerEpoch);	

	mean_pos=mean(feats(labels==1,:));
	mean_neg=mean(feats(labels==0,:));
	
	figure('name', sprintf('average responses of channel %s to particular stimuli during period %d', p3.channelNames{channelNo}, periodNo));
	for(stimulus = unique_stimuli)
		fprintf('Here we go for a stimulus \n');
		subplot(rows, cols, find(unique_stimuli==stimulus));
%  		printf('sum(stimuli==stimulus)=%d\n',sum(stimuli==stimulus));
%  		printf('size(feats(stimuli==stimulus, :))=%d,%d\n',size(feats(stimuli==stimulus, :)));
		
		plot(data_x, mean(feats(stimuli==stimulus, :),1),':');
		hold on;
		plot(data_x, mean_pos, 'g');
		hold on;
		plot(data_x, mean_neg, 'r');
		title(sprintf('stimulus: %d', stimulus));
	endfor;
endfunction;