function w=P3Workflow(p3session, trainTestMxFunction)
	w.p3session=p3session;
	w.functions={};
	w.functions.featsCompute={};
	w.functions.featsSelect={};
	w.functions.trainTest={};
	%a row for reach train-test iteration. negative indices indicate PERIODS(!!!) for validation
	w.trainTestSplitMx=feval(trainTestMxFunction,p3session.periodsCount);
	%uncomment when done debugging :)
	w=class(w, 'P3Workflow');
endfunction;