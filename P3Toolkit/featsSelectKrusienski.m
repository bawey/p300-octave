%using a 64-electrode cap, but some of the experiments use only a subset of 8 channels (,
%. Krusienski, et al., [37] empirically showed that this subset of electrodes

%  [37] D. Krusienski, E. Sellers, D. McFarland, T. Vaughan, and J. Wolpaw, “Toward enhanced P300
%  speller performance,” Journal of Neuroscience Methods, vol. 167, no. 1, pp. 15–21, 2008.



%labels are not used, yet they are always passed from the workflow and hence their presence
function mask = featsSelectKrusienski(feats, labels, p3s)
    channels = {'FZ', 'CZ', 'PZ', 'OZ', 'P3', 'P4', 'PO7', 'PO8'};
    mask=[];
    for(channel = channels) 
        idx=channelIndex(p3s, channel);
        if(idx>0)
            mask=[mask, channelColumnsSelector(p3s, idx)];
        endif;
    endfor;
endfunction;