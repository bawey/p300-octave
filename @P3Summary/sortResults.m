function [coords, value] = sortResults(p3summary, mode='naive')
    summary=p3summary.confusionMatrix;
    scoreboard=struct();
    scoreboard.naive=[];
    scoreboard.aware=[];
    scoreboard.(mode)=[];
    for(x=1:length(summary))
        for(y=1:length(summary{x}))
            for(z=1:length(summary{x}{y}))
            
                %% naive and named stats block
                [info, stats]=confusionMatrixInfo(summary{x}{y}{z}.naive);
                if(strcmp('naive', mode) == 0 && strcmp('aware', mode) == 0)
                    if(strcmp(mode, 'confgap'))
                        scoreboard.(mode)= [scoreboard.(mode); summary{x}{y}{z}.('conf') / summary{x}{y}{z}.('overconf'), x, y, z];
                    endif;
                
                    if(ismember(mode, fieldnames(summary{x}{y}{z})))
                        scoreboard.(mode)=[scoreboard.(mode); summary{x}{y}{z}.(mode), x, y, z];
                        continue;
                    endif;
                    
                    if(ismember(mode, fieldnames(stats)))
                        scoreboard.(mode)=[scoreboard.(mode); stats.(mode), x, y, z];
                        continue;
                    endif;
                endif;
                scoreboard.naive=[scoreboard.naive; stats.accuracy, x, y, z];
                %% end of naive and named stats block

                %% aware stats block
                [info, stats]=confusionMatrixInfo(summary{x}{y}{z}.aware);
                scoreboard.aware=[scoreboard.aware; 0.01*stats.f1, x, y, z];
                %% end of aware stats block

                if(isfield(summary{x}{y}{z}, 'correctSymbols'))
                      scoreboard.aware(end, 1)+=summary{x}{y}{z}.correctSymbols;                  
                      scoreboard.naive(end, 1).*=(summary{x}{y}{z}.correctSymbols / p3summary.totalPeriods );
                      if(ismember(mode, {'microScore'}))
                        scoreboard.(mode) += (summary{x}{y}{z}.correctSymbols/10000);                  
                      endif;
                endif;
                
                if(isfield(summary{x}{y}{z}, 'msme') && ~isnan(summary{x}{y}{z}.msme))
%                      scoreboard.naive(end, 1)+=1/(summary{x}{y}{z}.msme);
                endif;
                
                if(isfield(summary{x}{y}{z}, 'mse') && ~isnan(summary{x}{y}{z}.mse))
                   scoreboard.naive(end, 1).+=0.001/(summary{x}{y}{z}.mse);
                    if(ismember(mode, {'microScore'}))
                        scoreboard.(mode) -= (summary{x}{y}{z}.mse/10000);                  
                    endif;
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
    [value, position] = sort(scores, sortOrder);
    coords=scoreboard.(mode)([position], [2:end]);
       
    %[sortResults(sum, 'f1')(:,3), sortResults(sum, 'accuracy')(:,3), sortResults(sum, 'mse')(:,3)] sth like this
    
endfunction;