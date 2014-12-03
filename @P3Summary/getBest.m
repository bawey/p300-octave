% function best = getBest(p3summary, mode='naive', index=1)
function best = getBest(p3summary, mode='naive', index=1)
    best=struct();
    [coords, scores]=sortResults(p3summary, mode);
    best.featsCompute=p3summary.functions.featsCompute{coords(index,1)};
    best.featsSelect=p3summary.functions.featsSelect{coords(index,2)};
    best.trainTest=p3summary.functions.trainTest{coords(index,3)};
    
    %rearrange them as cells
    for(name = fieldnames(best)')
        name=name{:};
%       printf('looking at name %s \n', name);
        best.(name)={best.(name).functionHandle, best.(name).arguments{:}};
    endfor;
    
endfunction;