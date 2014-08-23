
	%stimuli 32780 - neutral it seems
	
	%rows 1-6: 33025-33030
	%cols 1-6: 33031-33036


function p3session = P3SessionOpenVibe(ov_path)

	TOLERANCE=0.00001;
	EPOCH_LENGTH=100;

	signal_raw=dlmread(strcat(ov_path,"/signal"), 	SEP=';');
	stimuli	=dlmread(strcat(ov_path,"/stimuli"), 	SEP=';');
	targets	=dlmread(strcat(ov_path,"/targets"), 	SEP=';');

	[time_label,ch1,ch2,ch3,ch4,ch5,ch6,ch7,ch8,ch9,ch10,ch11,ch12,ch13,ch14,rate]=textread(strcat(ov_path,'/signal'), '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', FORMAT_REPEAT=1, 'delimiter',';,');
	channels={ch1{:},ch2{:},ch3{:},ch4{:},ch5{:},ch6{:},ch7{:},ch8{:},ch9{:},ch10{:},ch11{:},ch12{:},ch13{:},ch14{:}};

	%targets and stimuli have to be marked as -6...-1 and 1...6
	stuffToTranscode={};
	stuffToTranscode{1}=stimuli;
	stuffToTranscode{2}=targets;
	
	for(i=1:length(stuffToTranscode))
		%cols become 1:6, rows -5:0
		stuffToTranscode{i}(:,2).-=33030;
		%ones for stuffToTranscode{i} > 0, 0 otherwise
		_pos=stuffToTranscode{i}(:,2)>0;
		%6 for stuffToTranscode{i} < 0, 0 otherwise
		norm1=~_pos*6;
		%stuffToTranscode{i} < 0 are shifted 6 notches up
		stuffToTranscode{i}(:,2)+=norm1;
		%columns have to become *=-1
		stuffToTranscode{i}(:,2).*=-sign(_pos-0.5);
	endfor;

	stimuli=stuffToTranscode{1};
	targets=stuffToTranscode{2};
		
	newStimuli=[];
	newTargets=[];
	signal=[];
	targetRow=1;
	
	while(targetRow<size(targets,1))
		if(abs(targets(targetRow,1) - targets(targetRow+1,1))<TOLERANCE)
			newTargets=[newTargets; targets(targetRow,1), targets(targetRow,2), targets(targetRow+1, 2)];
			targetRow+=2;
		else
			++targetRow;
		end;
	end;
	
	stimuli=stimuli(abs(stimuli(:,2))<10,:);
	
	targets=newTargets;

	for(trg=1:size(targets,1))
		
		target_time=targets(trg, 1);
		next_target_time=Inf;
		if(trg<size(targets,1))
			next_target_time=targets(trg+1,1);
		end;
		stimuli_selector=stimuli(:,1)>target_time & stimuli(:,1)<next_target_time;
		stimuli_for_target=stimuli(stimuli_selector, :);
		
		%stimuli: store stimuli for current target
		newStimuli=[newStimuli; stimuli_for_target(:,2)];
		
		period_signal=[];
		
		for(stm=1:size(stimuli_for_target,1))
			stimulus_time=stimuli_for_target(stm,1);
			samples_selector=signal_raw(:,1)>=(stimulus_time-0.001) & signal_raw(:,1)<=stimulus_time+2;
			samples_for_stimulus=signal_raw(samples_selector, :);
			period_signal=[period_signal; vec(samples_for_stimulus(1:EPOCH_LENGTH,2:end-1))'];
		end;
		
		%period-wise 'normalization'
		chn_offsets=1:EPOCH_LENGTH:columns(period_signal)-EPOCH_LENGTH+1;
		
		for(offset=chn_offsets)
			tmp=vec(period_signal(:,offset:(offset+EPOCH_LENGTH-1))');
			tmp=tmp-mean(tmp);
			period_signal(:,offset:(offset+EPOCH_LENGTH-1))=reshape(tmp, EPOCH_LENGTH, length(tmp)/EPOCH_LENGTH)';
		endfor;
		
		signal=[signal; period_signal];
	end;
	
	stimuli=newStimuli;
%  	printf('yep: %d, nah: %d \n', yep, nah);
	p3session=P3Session(signal, stimuli, targets(:,2:3), columns(signal_raw)-2, max(signal_raw(:,end)), channels);
		
endfunction;