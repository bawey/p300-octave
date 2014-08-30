%   prints the results from summary produced by P3Workfol.launch
%
%   sample invocation:
%       summarize(summary, fc, fs, cl)
%
function summarize(summary, fc, fs, cl)
    %let's try to rank all the methods: naive and aware separately
    
    scoreboard.naive=[];
    scoreboard.aware=[];
    
	for(x=1:length(summary))
		for(y=1:length(summary{x}))
			for(z=1:length(summary{x}{y}))
                [info, stats]=confusionMatrixInfo(summary{x}{y}{z}.naive);
%  				printf('feats computation: %15s, feats selection: %20s, classifier (naive): %10s , %s', fc{x}, fs{y}, cl{z}, info);
				scoreboard.naive=[scoreboard.naive; (stats.precision+stats.recall)/2, x, y, z];
				
				[info, stats]=confusionMatrixInfo(summary{x}{y}{z}.aware);
%  				printf('feats computation: %15s, feats selection: %20s, classifier (aware): %10s , %s', fc{x}, fs{y}, cl{z}, info);
				scoreboard.aware=[scoreboard.aware; (stats.precision+stats.recall)/2, x, y, z];
			endfor;
		endfor;
	endfor;
	
	printf('\n*** Scoreboard (precision + recall)/2 of NAIVE methods: ***\n');
	[val, idx] = sort(scoreboard.naive(:,1), 'descend');
	for(i = idx')
        x=scoreboard.naive(i, 2);
        y=scoreboard.naive(i, 3);
        z=scoreboard.naive(i, 4);
        printf('feats computation: %15s, feats selection: %20s, classifier: %10s , %s', fc{x}, fs{y}, cl{z}, confusionMatrixInfo(summary{x}{y}{z}.naive));
	endfor;
	
	printf('\n*** Scoreboard (precision + recall)/2 of AWARE methods: ***\n');
	[val, idx] = sort(scoreboard.aware(:,1), 'descend');
	for(i=idx')
        x=scoreboard.aware(i, 2);
        y=scoreboard.aware(i, 3);
        z=scoreboard.aware(i, 4);
        printf('feats computation: %15s, feats selection: %20s, classifier: %10s , %s', fc{x}, fs{y}, cl{z}, confusionMatrixInfo(summary{x}{y}{z}.aware));
	endfor;
	
endfunction;