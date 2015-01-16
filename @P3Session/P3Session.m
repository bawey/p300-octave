% P3Session(signal, stimuli, targets, channelsCount, samplingRate, channelNames, silent=true)
function p3Session = P3Session(signal, stimuli, targets, channelsCount, samplingRate, channelNames, silent=true)
	
	p3Session.samplingRate=samplingRate;
	p3Session.channelsCount=channelsCount;
	p3Session.periodsCount=size(targets,1);
	p3Session.channelNames=channelNames;
	p3Session.epochsCountPerPeriod=size(signal,1)/p3Session.periodsCount;
	p3Session.epochsCountPerStimulus=p3Session.epochsCountPerPeriod/length(unique(stimuli));
	p3Session.samplesCountPerEpoch=size(signal,2)/channelsCount;
	
	p3Session.signal=signal;
	p3Session.targets=targets;
	p3Session.stimuli=stimuli;

	if(length(channelNames)~=p3Session.channelsCount)
		error('Channel names length does not match the channels count. %d vs %d', length(channelNames), p3Session.channelsCount);
	endif;


	%let's store some nicely formatted info too
	p3Session.stats.('sampling rate [Hz]')	=	p3Session.samplingRate;
	p3Session.stats.('number of channels')	=	p3Session.channelsCount;
	p3Session.stats.('number of periods')	=	p3Session.periodsCount;
	p3Session.stats.('epochs per period')	=	p3Session.epochsCountPerPeriod;
	p3Session.stats.('epochs per stimulus')	=	p3Session.epochsCountPerStimulus;
	p3Session.stats.('samples per epoch')	=	p3Session.samplesCountPerEpoch;
	p3Session.stats.('total epochs')		=	size(p3Session.signal,1);
	p3Session.stats.('total stimuli')		=	size(p3Session.stimuli, 1);

	
	%we want a row of labels too. should be easily inferrable from stimuli and targets...
	
	%helper - index pointing to the target
	p3Session.labels=[];
	if(~isempty(targets))
		trg_ind=idivide(0:length(p3Session.stimuli)-1, p3Session.epochsCountPerPeriod)'+1;
		p3Session.labels= p3Session.stimuli == p3Session.targets(trg_ind, 2) | p3Session.stimuli == p3Session.targets(trg_ind, 1);
	endif;


	p3Session=class(p3Session, 'P3Session');

	if(~silent)
        %---SUMMARY OF LOADED DATA---
        printf('--------------------%s----------------------\n','SUMMARY OF LOADED DATA');
        for(fname = fieldnames(p3Session.stats)')
            printf('%40s  : %10d \n', fname{:}, p3Session.stats.(fname{:}));
        endfor;
	endif;
	
	
endfunction;
