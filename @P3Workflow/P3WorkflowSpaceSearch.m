function w = P3WorkflowClassifierGridSearch(p3train, splitCell, classifierCell)
    w=P3Workflow(p3train, splitCell);
    
    w=addFunction(w,    'featsCompute',    @featsComputePassThrough);
    
    for(ksr = [0.1 0.3 0.7 1 2 3 5])
        w=addFunction(w, 'featsCompute',    @featsComputePCAWithKSR, ksr);
    endfor;
    
    %this might go obsolete in the future.... or nope :) let's just code expert knowledge to exclude PCA and such
    w=addFunction(w, 'featsSelect',     @featsSelectPassThrough);
    %   w=addFunction(w, 'featsSelect',     @featsSelectKrusienski, w.p3session);            fs{end+1}='pass-through';
        
    for(corrthreshold=[0.001, 0.005, 0.01, 0.05, 0.1, 0.25])
        w=addFunction(w, 'featsSelect', @featsSelectFss, corrthreshold);
    endfor;
    
endfunction;

        
