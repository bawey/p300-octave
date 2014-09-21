function texize(p3summary, stage)
    [coords value] = sortResults(p3summary);
    
    if(stage==1)
        %============== this prints crude stage 1 summary =================
        printf('Klasyfikator & Parametry & Znaki & F1 & mse & msme \\\\ \n')
        printf('\\hline \n');
        for(coordSet=coords')
            
            %copy-paste compatibility
            x=coordSet(1);
            y=coordSet(2);
            z=coordSet(3);
            summary=p3summary.confusionMatrix;
            
            fcFunc=p3summary.functions.featsCompute{coordSet(1)};
            fsFunc=p3summary.functions.featsSelect{coordSet(2)};
            ttFunc=p3summary.functions.trainTest{coordSet(3)};
            
            charRight=0;
            mse=1;
            msme=1;
            
            if(isfield(summary{x}{y}{z},'correctSymbols'))
                charRight = summary{x}{y}{z}.correctSymbols;
            endif;
            
            if(isfield(summary{x}{y}{z},'mse'))
                mse = summary{x}{y}{z}.mse;
            endif;
            
            if(isfield(summary{x}{y}{z},'msme'))
                msme = summary{x}{y}{z}.msme/12;
            endif;

            
            
            [info, stats]=confusionMatrixInfo(p3summary.confusionMatrix{coordSet(1)}{coordSet(2)}{coordSet(3)}.naive);
            
            paramString=stringify(ttFunc.arguments);
            functionName = func2str(ttFunc.functionHandle);
            
            if(strcmp(functionName, func2str(@BalancedClassifier))==1)
                functionName=func2str(ttFunc.arguments{1}{1});
                ttFunc.arguments{1}=ttFunc.arguments{1}(2:end);
            endif;
            
            if(strcmp(functionName, func2str(@ClassifierNan)))
                MODE=ttFunc.arguments{1}{1};
                functionName=MODE.TYPE;
                if(strcmp(functionName, 'SVM')==1)
                    paramString=sprintf('c=%.3g', MODE.hyperparameter.c_value);
                elseif(strcmp(functionName, 'FLDA')==1)
                    paramString=sprintf('$\\gamma=%.3g$', MODE.hyperparameter.gamma);
                endif;
            elseif (strcmp(functionName, func2str(@ClassifierLogReg)))
                functionName='Regresja logistyczna';
                paramString=sprintf('$\\lambda=%.3g$', ttFunc.arguments{1}{2});
            elseif (strcmp(functionName, func2str(@ClassifierNN)))
                functionName='Sieć neuronowa';
                paramString=sprintf('$\\|a^{(2)}\\|=%d$, $\\lambda=%.3g$', ttFunc.arguments{1}{1}, ttFunc.arguments{1}{3});
            endif;
            
            
            printf('\\hline\n');
            printf('%s & %s & %d & %.3f & %.3f & %.3f  \\\\\n', functionName, paramString, charRight, stats.f1, mse, msme);
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