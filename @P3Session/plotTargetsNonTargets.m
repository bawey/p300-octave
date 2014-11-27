function plotTargetsNonTargets(p3)

%  	figure_rows=ceil(sqrt(p3.channelsCount));
%  	figure_cols=figure_rows;
	x_data=linspace(0, p3.samplesCountPerEpoch/p3.samplingRate, p3.samplesCountPerEpoch);
	%for(channel = 1:p3.channelsCount)
	for(channel = 1:p3.channelsCount)
		if(mod(channel, 16)==1)
			figure('name',sprintf('responses overview for channels %d-%d',channel, min(channel+15, p3.channelsCount)));
		endif;
		[feats, labels, stimuli] = classificationData(p3, [channel], [1:p3.periodsCount]);
		pos=mean(feats(labels==1,:));
		neg=mean(feats(labels==0,:));

%  	Quick'n'dirty fix to align images nicer for 14-channel EPOC
        if(p3.channelsCount==14)
            subplot(2, 7, channel, 'align');
        else
            subplot(4, 4, mod(channel-1, 16)+1);
        endif;
		plot(x_data, pos, 'g');
		hold on;
		plot(x_data, neg, 'r');
		title(sprintf('%d: %s', channel, p3.channelNames{channel}));
		hold off;
%  		printf('plotted %d channel\n', channel);
		fflush(stdout);
		axis('nolabel');
	endfor;
endfunction;