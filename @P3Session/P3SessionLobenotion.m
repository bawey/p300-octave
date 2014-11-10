%Constructor for the project's own data format. Its fate is yet to be decided
% P3SessionLobenotion(dirpath, dataname, metaname, targetsname)
function p3session = P3SessionLobenotion(dirpath, dataname, metaname, targetsname)
	data = load(sprintf('%s/%s', dirpath, dataname));
	meta = load(sprintf('%s/%s', dirpath, metaname));
	targets = load(sprintf('%s/%s', dirpath, targetsname));

    epoch_length = 120;
    samples=size(meta,1);
    channels = size(data,2)-1;
	
	signal=repmat(NaN, rows(meta), channels*epoch_length);
	stimuli=meta(:,3);
	targets=targets(:,2:end);
	
	for(sampleNo=1:samples)
        onset = meta(sampleNo, 1);
        timemarks = data(data(:,1)>onset,1)(1:epoch_length);
        for(channelNo=1:channels)
            signal(sampleNo, ((channelNo-1)*epoch_length+1) : (channelNo*epoch_length) ) = data((data(:,1)>=timemarks(1) & data(:,1)<=timemarks(end)), channelNo+1)';
        endfor;
	endfor;
	assert(sum(isnan(signal)(:))==0);
  	p3session=P3Session(signal, stimuli, targets, 14, 128, {'AF3','AF4','F3','F4','F7','F8','FC5','FC6','T7','T8','P7','P8','O1','O2'});
endfunction;