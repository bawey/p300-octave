function [coords, value] = sortResults(p3summary, mode='naive')
    summary=p3summary.confusionMatrix;
    scoreboard=struct();
    scoreboard.naive=[];
    scoreboard.aware=[];
    for(x=1:length(summary))
        for(y=1:length(summary{x}))
            for(z=1:length(summary{x}{y}))
                [info, stats]=confusionMatrixInfo(summary{x}{y}{z}.naive);
%               printf('feats computation: %15s, feats selection: %20s, classifier (naive): %10s , %s', fc{x}, fs{y}, cl{z}, info);
                scoreboard.naive=[scoreboard.naive; stats.f1*0.01, x, y, z];

                [info, stats]=confusionMatrixInfo(summary{x}{y}{z}.aware);
%               printf('feats computation: %15s, feats selection: %20s, classifier (aware): %10s , %s', fc{x}, fs{y}, cl{z}, info);
                scoreboard.aware=[scoreboard.aware; stats.f1*0.01, x, y, z];

                if(isfield(summary{x}{y}{z}, 'correctSymbols'))
                    scoreboard.naive(end, 1)+=summary{x}{y}{z}.correctSymbols;
                endif;
                
                 if(isfield(summary{x}{y}{z},'fewestRepeats'))
                    scoreboard.naive(end, 1)+=(1/summary{x}{y}{z}.fewestRepeats);
                endif;
                
                if(isfield(summary{x}{y}{z}, 'msme') && ~isnan(summary{x}{y}{z}.msme))
                      scoreboard.naive(end, 1)+=(summary{x}{y}{z}.msme * -0.000001);
                endif;

                if(isfield(summary{x}{y}{z}, 'mse') && ~isnan(summary{x}{y}{z}.msme))
                      scoreboard.naive(end, 1)+=(summary{x}{y}{z}.mse * -0.0000000001);
                endif;

            endfor;
        endfor;
    endfor;
    
    %NaN score needs to be replaced by 0
    scores = scoreboard.(mode)(:,1);
    scores(isnan(scores))=0;
    
%   [value, position] = sort(scoreboard.(mode)(:,1), 'descend');
    [value, position] = sort(scores, 'descend');
    coords=scoreboard.(mode)([position], [2:end]);
    
endfunction;

    