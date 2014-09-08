function best = getBest(p3summary, mode='aware')
    best=struct();
    [coords, scores]=sortResults(p3summary, mode);
    best.featsCompute=p3summary.functions.featsCompute{coords(1,1)};
    best.featsSelect=p3summary.functions.featsSelect{coords(1,2)};
    best.trainTest=p3summary.functions.trainTest{coords(1,3)};
    
    %rearrange them as cells
    for(name = fieldnames(best)')
        name=name{:};
        printf('looking at name %s \n', name);
        best.(name)={best.(name).functionHandle, best.(name).arguments{:}};
    endfor;
    
endfunction;