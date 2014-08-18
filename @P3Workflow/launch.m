% goes over all the stages defined for P3Workflow and executes the code
function summary = launch(wf)
	%nobody does the cross-validation splotting now :(
	%and there is no voting... cause there is nothing to vote about
	printf('Launching the workflow for %d feature computation methods, %d feature selection methods and %d classification startegies. \n', 
		length(wf.functions.featsCompute), length(wf.functions.featsSelect), length(wf.functions.classify));

	summary={};
	
	combinationsToRun=size(wf.trainTestSplitMx,1) * length(wf.functions.featsCompute) * length(wf.functions.featsSelect) * length(wf.functions.classify);
	progress=0;
	
	printf('Workflow progress: %.2f\r', progress);
	
	for(sv = wf.trainTestSplitMx')
		sv=sv';
%  		fprintf('Periods for training: ')
%  		sv(sv>0)
		[tfeats, tlabels, tstimuli] = classificationData(wf.p3session, [1:wf.p3session.channelsCount], [sv(sv>0)]);
		[vfeats, vlabels, vstimuli] = classificationData(wf.p3session, [1:wf.p3session.channelsCount], [-sv(sv<0)]);
		[tfeats, vfeats] = centerData(tfeats, vfeats);
%  		printf('Evaluation period: %d \n', -sv(sv<0));
		for(x=1:length(wf.functions.featsCompute))
			if(length(summary)<x)	summary{end+1}={};	endif;
			
			[tfeats, vfeats] = featsCompute(wf, x, tfeats, tlabels, vfeats);
			for(y=1:length(wf.functions.featsSelect))
				
				if(length(summary{x})<y)	summary{x}{end+1}={};	endif;
				
				featureIdx = featsSelect(wf, y, tfeats, tlabels);
				for(z=1:length(wf.functions.classify))
					if(length(summary{x}{y})<z)	summary{x}{y}{end+1}=struct('naive',zeros(2,2),'aware',zeros(2,2)); endif;
					%[H, IH]=parcellfun(3, @classify, {wf, z, tfeats(:,featureIdx), tlabels, vfeats(:,featureIdx), vlabels});
					[H, IH]=classify(wf, z, tfeats(:,featureIdx), tlabels, vfeats(:,featureIdx), vlabels);
					summary{x}{y}{z}.naive+=H;
					summary{x}{y}{z}.aware+=IH;
					
					printf('Workflow progress: %.2f%%\r', ++progress*100/combinationsToRun);
					fflush(stdout);
				endfor;
			endfor;
		endfor;
	endfor;
	printf('\n');
endfunction;