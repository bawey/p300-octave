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
                [info, stats]=confusionMatrixInfo(summary{x}{y}{z}.aware);
%               printf('feats computation: %15s, feats selection: %20s, classifier (aware): %10s , %s', fc{x}, fs{y}, cl{z}, info);
                scoreboard.aware=[scoreboard.aware; (stats.precision+stats.recall)/2, x, y, z];
                
                
                printf('FC: %15s, FS: %20s, CL: %10s, PR and ACC: %.2f\\%% & %.2f\\%% \\\\ \n', fc{x}, fs{y}, cl{z}, stats.precision*100, stats.accuracy*100);
                
                
            endfor;
        endfor;
    endfor;
    
    
endfunction;