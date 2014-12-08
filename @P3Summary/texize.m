function texize(p3summary, stage, mode='correctSymbols')
    [coords value] = sortResults(p3summary, mode);
    
    if(stage==1)
        %============== this prints crude stage 1 summary =================
        if(isfield(p3summary.confusionMatrix{1}{1}{1}, 'microScore'))
            printf('\\textbf{Lp.} & \\textbf{Klasyfikator} & \\textbf{Znaki} & \\textbf{mscore} & \\textbf{MSE} & \\textbf{Trafność} & \\textbf{F1} \\\\ \n')
        else
            printf('\\textbf{Lp.} & \\textbf{Klasyfikator} & \\textbf{Znaki} & \\textbf{MSE} & \\textbf{Trafność} & \\textbf{F1} \\\\ \n')
        endif;
        printf('\\hline \n');
        number = 0;
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
            microScore=0;
            
            if(isfield(summary{x}{y}{z},'mse'))
                mse = summary{x}{y}{z}.mse;
            endif;
            
            if(isfield(summary{x}{y}{z},'microScore'))
                microScore = summary{x}{y}{z}.microScore;
            endif;
            
            if(isfield(summary{x}{y}{z},'correctSymbols'))
                charRight = summary{x}{y}{z}.correctSymbols;
            endif;
            
            [info, stats]=confusionMatrixInfo(p3summary.confusionMatrix{coordSet(1)}{coordSet(2)}{coordSet(3)}.naive);
            
            paramString=stringify(ttFunc.arguments);
            functionName = func2str(ttFunc.functionHandle);
            balancedStr = '';
            
            if(strcmp(functionName, func2str(@BalancedClassifier))==1)
                balancedStr = 'Meta ';
                functionName=sprintf('%s',func2str(ttFunc.arguments{1}{1}));
                ttFunc.arguments=ttFunc.arguments{1}(2:end);
            endif;
            
            if(strcmp(functionName, func2str(@ClassifierNan)))
                MODE=ttFunc.arguments{1};
                functionName=MODE.TYPE;
                if(strcmp(functionName, 'SVM')==1)
                    paramString=sprintf('c=%.3g', MODE.hyperparameter.c_value);
                elseif(strcmp(functionName, 'FLDA')==1)
                    paramString=sprintf('$\\gamma=%.3g$', MODE.hyperparameter.gamma);
                endif;
            elseif (strcmp(functionName, func2str(@ClassifierLogReg)))
                functionName='LR';
                paramString=sprintf('$\\lambda=%.3g$', ttFunc.arguments{2});
            elseif (strcmp(functionName, func2str(@ClassifierNN)))
                functionName='NN';
                paramString=sprintf('$\\|a^{(2)}\\|=%d$, $\\lambda=%.3g$', ttFunc.arguments{1}, ttFunc.arguments{3});
            endif;
            
            if(isfield(summary{x}{y}{z},'microScore'))
                printf('%0d. & %s%s, %s & %d/%d & %.3f & %.3f & %.2f\\%% & %.3f \\\\\n', (++number), balancedStr, functionName, paramString, charRight, p3summary.totalPeriods, microScore, mse, stats.accuracy*100, stats.f1);
            else
                printf('%0d. & %s%s, %s & %d/%d & %.3f & %.2f\\%% & %.3f \\\\\n', (++number), balancedStr, functionName, paramString, charRight, p3summary.totalPeriods, mse, stats.accuracy*100, stats.f1);
            endif;                            
            printf('\\hline \n');
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
        
        elseif(stage==3)
        %============== this prints crude stage 1 summary, but with microscore instead of other metrics =================
        printf('\\hline \n');
        printf('\\textbf{Lp.} & \\textbf{Klasyfikator} & \\textbf{Znaki} & \\textbf{microScore} \\textbf{MSE} & \\textbf{Trafność} & \\textbf{F1} \\\\ \n')
        printf('\\hline \n');
        number = 0;
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
            
            if(isfield(summary{x}{y}{z},'mse'))
                mse = summary{x}{y}{z}.mse;
            endif;
            
            if(isfield(summary{x}{y}{z},'correctSymbols'))
                charRight = summary{x}{y}{z}.correctSymbols;
            endif;
            
            [info, stats]=confusionMatrixInfo(p3summary.confusionMatrix{coordSet(1)}{coordSet(2)}{coordSet(3)}.naive);
            
            paramString=stringify(ttFunc.arguments);
            functionName = func2str(ttFunc.functionHandle);
            balancedStr = '';
            
            if(strcmp(functionName, func2str(@BalancedClassifier))==1)
                balancedStr = 'META ';
                functionName=sprintf('%s',func2str(ttFunc.arguments{1}{1}));
                ttFunc.arguments=ttFunc.arguments{1}(2:end);
            endif;
            
            if(strcmp(functionName, func2str(@ClassifierNan)))
                MODE=ttFunc.arguments{1};
                functionName=MODE.TYPE;
                if(strcmp(functionName, 'SVM')==1)
                    paramString=sprintf('c=%.3g', MODE.hyperparameter.c_value);
                elseif(strcmp(functionName, 'FLDA')==1)
                    paramString=sprintf('$\\gamma=%.3g$', MODE.hyperparameter.gamma);
                endif;
            elseif (strcmp(functionName, func2str(@ClassifierLogReg)))
                functionName='Regresja logistyczna';
                paramString=sprintf('$\\lambda=%.3g$', ttFunc.arguments{2});
            elseif (strcmp(functionName, func2str(@ClassifierNN)))
                functionName='Sieć neuronowa';
                paramString=sprintf('$\\|a^{(2)}\\|=%d$, $\\lambda=%.3g$', ttFunc.arguments{1}, ttFunc.arguments{3});
            endif;
            
                        
            printf('%0d. & %s%s, %s & %d/%d & %.3f & %.2f\\%% & %.3f \\\\\n', (++number), balancedStr, functionName, paramString, charRight,  p3summary.totalPeriods, mse, stats.accuracy*100, stats.f1);
            printf('\\hline \n');
        endfor;
        
        
    endif;
    fflush(stdout);
endfunction;