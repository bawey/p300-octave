% goes over all the stages defined for P3Workflow and executes the code
function p3summary = launch(wf, title='untitled')
	%nobody does the cross-validation splotting now :(
	%and there is no voting... cause there is nothing to vote about
	printf('Launching the workflow for %d feature computation methods, %d feature selection methods and %d classification startegies. \n', 
		length(wf.functions.featsCompute), length(wf.functions.featsSelect), length(wf.functions.trainTest));

	summary={};
	testPeriods={};
	trainPeriods={};
	
	%for saving the file later
	[status, datestr]=system('date +"%Y.%m.%d_%H.%M"');
        
        filename=sprintf('~/p3results/summary.%s.%s.oct', title, strtrim(datestr));
	
	combinationsToRun=size(wf.trainTestSplitMx,1) * length(wf.functions.featsCompute) * length(wf.functions.featsSelect) * length(wf.functions.trainTest);
	progress=0;
	
	printf('Workflow progress: %.2f\r', progress); fflush(stdout);
	for(sv = wf.trainTestSplitMx')
		sv=sv';
%  		fprintf('Periods for training: ')
%  		sv(sv>0)
		[tfeats, tlabels, tstimuli] = classificationData(wf.p3session, [1:wf.p3session.channelsCount], [sv(sv>0)]);
		trainPeriods{end+1}=[sv(sv>0)];
		[vfeats, vlabels, vstimuli] = classificationData(wf.p3session, [1:wf.p3session.channelsCount], [-sv(sv<0)]);
		testPeriods{end+1}=[-sv(sv<0)];
		
		[tfeats, vfeats] = centerData(tfeats, vfeats);
		
%  		printf('Evaluation period: %d \n', -sv(sv<0));
		for(x=1:length(wf.functions.featsCompute))
			if(length(summary)<x)	summary{end+1}={};	endif;
			
			%Compute the steps of feature space transformation. Then apply them to both training and test data
            transSteps = transSteps=feval(wf.functions.featsCompute{x}.functionHandle, tfeats, tlabels, wf.functions.featsCompute{x}.arguments{:});
			tfeats=executeTransformationSteps(tfeats, transSteps);
			vfeats=executeTransformationSteps(vfeats, transSteps);

			for(y=1:length(wf.functions.featsSelect))
				if(length(summary{x})<y)	summary{x}{end+1}={};	endif;
				
				featureIdx = featsSelect(wf, y, tfeats, tlabels);
				for(z=1:length(wf.functions.trainTest))
					if(length(summary{x}{y})<z)	summary{x}{y}{end+1}=struct('naive',zeros(2,2),'aware',zeros(2,2)); endif;
					
					funobj=wf.functions.trainTest{z};
					
					if(ismember('bagging', fieldnames(funobj)) && funobj.bagging==true)
                        [H, IH]=trainTest(wf, z, vfeats(:,featureIdx), vlabels, tfeats(:,featureIdx), tlabels, tstimuli, wf.p3session.epochsCountPerPeriod);
                    else
                        [H, IH]=trainTest(wf, z, tfeats(:,featureIdx), tlabels, vfeats(:,featureIdx), vlabels, vstimuli, wf.p3session.epochsCountPerPeriod);
					endif;
  					
    				summary{x}{y}{z}.naive+=H;
    				summary{x}{y}{z}.aware+=IH;
					
					printf('Workflow progress: %.2f%%\n', ++progress*100/combinationsToRun);
					fflush(stdout);
					
%  					save('-binary', filename, 'summary', 'title', 'fc', 'fs', 'tt');
				endfor;
			endfor;
		endfor;
	endfor;
	printf('\n');
	
	%P3Summary object containing info about the methods used and their confusion matrices
	p3summary=P3Summary(wf.functions, summary);
endfunction;