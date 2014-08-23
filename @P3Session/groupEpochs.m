%Merges each period into a set of 12 epochs, each being the average response to a particular stimulus
function p3session = groupEpochs(p3session)
	new_signal=[];
	new_stimuli=[];
	
	for(periodNo=1:p3session.periodsCount)
		period_signal=[];
	
		row_selector=ismember(1:size(p3session.stimuli,1), [1:p3session.epochsCountPerPeriod]+(periodNo-1)*p3session.epochsCountPerPeriod)';
		period_stimuli=unique(p3session.stimuli(row_selector,:));
		for(stimulus=period_stimuli')
%  			printf('size of stimulus is... %d, %d \n', size(stimulus));
			temp_mean=mean(p3session.signal(row_selector & p3session.stimuli(:,1)==stimulus, :));
			period_signal=[period_signal; temp_mean];
		endfor;
		
		new_signal=[new_signal; period_signal];
		new_stimuli=[new_stimuli; period_stimuli];
		
	endfor;
	
	p3session = P3Session(new_signal, new_stimuli, p3session.targets, p3session.channelsCount, p3session.samplingRate, p3session.channelNames);
endfunction;