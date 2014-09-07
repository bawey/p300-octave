function texize(p3summary, stage)
    [coords value] = sortResults(p3summary);
    
    if(stage==1)
        %============== this prints crude stage 1 summary =================
        printf('Klasyfikator & Parametry & Precyzja & Trafność \\\\ \n')
        printf('\hline \n');
        for(coordSet=coords')
            
            fcFunc=p3summary.functions.featsCompute{coordSet(1)};
            fsFunc=p3summary.functions.featsSelect{coordSet(2)};
            ttFunc=p3summary.functions.trainTest{coordSet(3)};
            
            
            [info, stats]=confusionMatrixInfo(p3summary.confusionMatrix{coordSet(1)}{coordSet(2)}{coordSet(3)}.aware);
            
            printf('%s & %s & %.2f\\%% & %.2f\\%%  \\\\\n', func2str(ttFunc.functionHandle), stringify(ttFunc.arguments), stats.precision*100, stats.accuracy*100);
        endfor;
        %=============== this prints crude stage 2 summary =================
    elseif(stage==2)
        tt=p3summary.functions.trainTest;
        printf('Section 2! for %d train-test functions\n \n', length(tt));
        fflush(stdout);
        for(tti=1:length(tt))
            printf('Section 2  %s \n', stringify(tt{tti}));

            fc=p3summary.functions.featsCompute;
            fs=p3summary.functions.featsSelect;
            
            for(fsi=1:length(fs))
                printf(' & %s', stringify({fs{fsi}.functionHandle, fs{fsi}.arguments{:}}));
            endfor;
            printf('\\\\ \n');
            
            fflush(stdout);
            for(fci=1:length(fc))
            
                printf('%s & ', stringify({fc{fci}.functionHandle, fc{fci}.arguments{:}}));
            
                for(fsi=1:length(fs))
                    [info, stats]=confusionMatrixInfo(p3summary.confusionMatrix{fci}{fsi}{tti}.aware);
                    printf('%.2f\\%%', stats.precision*100);
                    if(fsi<length(fs))
                        printf(' & ');
                    endif;
                endfor;
                printf('\\\\ \n');
            endfor;
        endfor;
    endif;
    fflush(stdout);
endfunction;