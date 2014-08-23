%Constructor for the project's own data format. Its fate is yet to be decided
function p3session = P3SessionLobenotion(dirpath, dataname, metaname)
	data = load(sprintf('%s/%s', dirpath, dataname));
	meta = load(sprintf('%s/%s', dirpath, metaname));
	
	signal=[];
	stimuli=[];
	targets=[];
	
	%inter-stimuli intervals
	a=meta(2:end,1)-[meta(1:end-1,1)];
	%long ISI indicates a beginning of new period. b holds indices of new period beginnings
	b=find(a>2000);
	%this shows how many intensifications there were per period
	c=b-[0;b(1:end-1)]
	%we could want to asert c is of 0 variance...
	
	%indices of stimuli, one period per row
	d=linspace(b,b+mean(c)-1, mean(c));
	for(di=1:size(d,1))
		%temp now holds all the stimuli for di-th period
		tmp=meta(d(di,:),:);
		%targets now are the two targett-ed stimuli :)
		local_targets=sort(unique(tmp(tmp(:,2)==1,3)),'descend')'
		targets=[targets; local_targets];
	endfor;
	targets
	fprintf('Successfully loaded %d rows and %d columns of data! \n', columns(data), rows(data));
	
%  	p3session=P3Session(signal, stimuli, targets, 14, 128, {'AF3','AF4','F3','F4','F7','F8','FC5','FC6','T7','T8','P7','P8','O1','O2'});
endfunction;