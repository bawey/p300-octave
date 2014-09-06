%       creates an empty workflow for given p3session and x-validation splitting methods
%       sample invocations:
%               w=P3Workflow(p3session, {@trainTestSplitMx, 10})
function w=P3Workflow(p3session, splitCell)
	w.p3session=p3session;
	w.functions={};
	w.functions.featsCompute={};
	w.functions.featsSelect={};
	w.functions.trainTest={};
	%a row for reach train-test iteration. negative indices indicate PERIODS(!!!) for validation
	w.trainTestSplitMx=feval(splitCell{1},p3session.periodsCount, splitCell{[1:end]~=1});
	%uncomment when done debugging :)
	
	%keep formatting strings used to describe the methods (UNUSED RIGHT NOW!)
	labels=struct();
	labels.fc=struct();
	labels.fs=struct();
	labels.tt=struct();
	
	w=class(w, 'P3Workflow');
endfunction;