    barcolors={'r','g','b','m','c','y'}
    for(x=1:length(summary))
        data=zeros(length(summary{x}{1}) * length(summary{x}), 1);
        for(y=1:length(summary{x}))
            for(z=1:length(summary{x}{y}))
                [info, stats]=confusionMatrixInfo(summary{x}{y}{z}.aware);
                data((y-1)*length(summary{x})+z, 1)=(stats.precision+stats.recall)/2;
            endfor;
        endfor;
        figure();
        size(data)
        h=bar(data');
        for(hi=1:columns(data'))
            barcolors{hi}
            set(h(hi), 'facecolor', barcolors{mod(hi, length(barcolors))+1}, 'basevalue', 0.5);
        endfor;
    endfor;