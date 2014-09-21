%   sample invocation:
%       summarize(p3summary)
%
function summarize(p3summary)
    %let's try to rank all the methods: naive and aware separately
    
    summary=p3summary.confusionMatrix;
    
    scoreboard.naive=[];
    scoreboard.aware=[];
    
    %====== GENERATE DESCRIPTIONS ======
    
    fc={};
    fs={};
    tt={};
    
    for(i=1:length(p3summary.functions.featsCompute))    
        funcStruct=p3summary.functions.featsCompute{i};
        fc{i}=stringify({funcStruct.functionHandle, funcStruct.arguments{:}});
    endfor;
    
    for(i=1:length(p3summary.functions.featsSelect))   
        funcStruct=p3summary.functions.featsSelect{i};
        fs{i}=stringify({funcStruct.functionHandle, funcStruct.arguments{:}});
    endfor;
    
    for(i=1:length(p3summary.functions.trainTest)) 
        funcStruct=p3summary.functions.trainTest{i};
        tt{i}=stringify({funcStruct.functionHandle, funcStruct.arguments{:}});
    endfor;
    
    %======DESCRIPTIONS GENERATED=========
    
        for(mode = {'naive'})
            mode=mode{:};
            printf('\n*** Scoreboard (precision + recall)/2 of %s methods: ***\n', mode);
            
            [coords, score] = sortResults(p3summary, mode);

            for(i = 1:rows(coords))
                x=coords(i,1);
                y=coords(i,2);
                z=coords(i,3);
                if(isfield(summary{x}{y}{z},'correctSymbols'))
                    printf('| char right: %d', summary{x}{y}{z}.correctSymbols);
                endif;
                if(isfield(summary{x}{y}{z},'mse'))
                    printf(' : mse: %.3f', summary{x}{y}{z}.mse);
                endif;
                if(isfield(summary{x}{y}{z},'msme'))
                    %todo: change this 6, it's here due to a /2 (unique values) in launch
                    printf(' : msme: %.3f', summary{x}{y}{z}.msme / 6);
                endif;

                printf(' : %s', confusionMatrixInfo(summary{x}{y}{z}.(mode)));
                
                printf(' : FC: %15s, FS: %20s, TT: %10s , %s ', fc{x}, fs{y}, tt{z});
                
                printf('\n');
            endfor;
            
        endfor;

endfunction;
