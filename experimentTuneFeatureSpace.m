%   This method uses cross-validated train-validate cycle to evaluate available approaches of feature space transformations.
%   Give us the workflow initialized with classifiers, classifiers descriptions and 'foldness' of cross validation. We'll do the rest...
%
%
%   experimentTuneFeaturesSpace(p3workflow, title, splitsCount=p3train.periodsCount)
%       p3workflow needs to be initialized with all desired training methods       
%
%
%   sample invocations:
%       experimentTuneFeatureSpace(p3worfklow, 'featuresTuningTest', 13)
%
function [summary, fc, fs, tt, title] = experimentTuneFeaturesSpace(w, tt, title, splitsCount=p3train.periodsCount)

    %some structures for pretty printing
    fc={};
    fs={};

    %fill up the P3Workflow
    w=addFunction(w, 'featsCompute',    @featsComputePassThrough);      fc{end+1}='pass-through';
    for(ksr = [0.1 0.3 0.7 1 2 3 5])
        w=addFunction(w, 'featsCompute',    @featsComputePCAWithKSR, ksr);     fc{end+1}=sprintf('PCA with ksr=%.2f', ksr);
    endfor;
    %this might go obsolete in the future.... or nope :) let's just code expert knowledge to exclude PCA and such
    w=addFunction(w, 'featsSelect',     @featsSelectPassThrough);          fs{end+1}='pass-through';
%   w=addFunction(w, 'featsSelect',     @featsSelectKrusienski, w.p3session);            fs{end+1}='pass-through';
    
    for(corrthreshold=[0.001, 0.005, 0.01, 0.05, 0.1, 0.25])
        w=addFunction(w, 'featsSelect', @featsSelectFss, corrthreshold); fs{end+1}=sprintf('correlation based (coeff=%.3f)', corrthreshold);
    endfor;
    
    printf('launching workflow...'); fflush(stdout);

    summary=launch(w, fc, fs, tt, title);
    summarize(summary, fc, fs, tt);
    %summary should return the best setup. or sort everything according to (recall+presision)
    
endfunction;



