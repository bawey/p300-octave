function [coords, value] = sortResults(p3summary, mode='naive')
    summary=p3summary.confusionMatrix;
    scoreboard=struct();
    scoreboard.naive=[];
    scoreboard.aware=[];
    scoreboard.(mode)=[];
    for(x=1:length(summary))
        for(y=1:length(summary{x}))
            for(z=1:length(summary{x}{y}))
                [info, stats]=confusionMatrixInfo(summary{x}{y}{z}.naive);
                
                if(strcmp('naive', mode) == 0 && strcmp('aware', mode) == 0)
                    if(ismember(mode, fieldnames(summary{x}{y}{z})))
                        scoreboard.(mode)=[scoreboard.(mode); summary{x}{y}{z}.(mode), x, y, z];
                        continue;
                    endif;
                    
                    if(ismember(mode, fieldnames(stats)))
                        scoreboard.(mode)=[scoreboard.(mode); stats.(mode), x, y, z];
                        continue;
                    endif;
                endif;
                
%               printf('feats computation: %15s, feats selection: %20s, classifier (naive): %10s , %s', fc{x}, fs{y}, cl{z}, info);
                scoreboard.naive=[scoreboard.naive; 100*stats.accuracy + 0.01*stats.f1, x, y, z];
%                          scoreboard.naive=[scoreboard.naive; 0, x, y, z];

                [info, stats]=confusionMatrixInfo(summary{x}{y}{z}.aware);
%               printf('feats computation: %15s, feats selection: %20s, classifier (aware): %10s , %s', fc{x}, fs{y}, cl{z}, info);
                scoreboard.aware=[scoreboard.aware; 0 + 0.01*stats.f1, x, y, z];

                if(isfield(summary{x}{y}{z}, 'correctSymbols'))
                      scoreboard.aware(end, 1)+=summary{x}{y}{z}.correctSymbols;
                endif;
                
                if(isfield(summary{x}{y}{z}, 'msme') && ~isnan(summary{x}{y}{z}.msme))
%                      scoreboard.naive(end, 1)+=1/(summary{x}{y}{z}.msme);
                endif;
                
                if(isfield(summary{x}{y}{z}, 'microScore'))
%                      scoreboard.naive(end, 1)+=(summary{x}{y}{z}.microScore);
                endif;
                

                if(isfield(summary{x}{y}{z}, 'mse') && ~isnan(summary{x}{y}{z}.mse))
%                          scoreboard.naive(end, 1)+=0.00001/(summary{x}{y}{z}.mse);
                endif;

            endfor;
        endfor;
    endfor;
    
    scores = scoreboard.(mode)(:,1);
    %NaN score needs to be replaced by 0
    scores(isnan(scores))=0;
    
%   [value, position] = sort(scoreboard.(mode)(:,1), 'descend');
    sortOrder = 'descend';
    if(ismember(mode,{'mse', 'msme', 'mste'}))
        sortOrder='ascend';
    endif;
    [value, position] = sort(scores, 'descend');
    coords=scoreboard.(mode)([position], [2:end]);
    
    %[sortResults(sum, 'f1')(:,3), sortResults(sum, 'accuracy')(:,3), sortResults(sum, 'mse')(:,3)] sth like this
    
endfunction;