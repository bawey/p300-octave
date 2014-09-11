%   labels are not used, yet they are always passed from the workflow and hence their presence
%   featsSelectRemoveListed(feats, labels, p3s, indices)
%   Berlin3a: [8 15 60 61 63 64 54 55 56 44 45 46 47 48]
function mask = featsSelectRemoveListed(feats, labels, p3s, indices)
    mask=[];
    for(idx=1:p3s.channelsCount)
        if(~ismember(idx, indices))
            mask=[mask, channelColumnsSelector(p3s, idx)];
        endif;
    endfor;
endfunction;