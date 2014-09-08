%dataFile=~/Forge/p3data/p3tt-berlin3b.12fold.oct
function [summary1] = flowtest(dataFile, cvSplits, grouped=false, title='untitled', classifiers='all')

%       a 'hack' to focus on the more promising algorithms first, while the slow ones compute elsewhere
    if(strcmp(classifiers,'all')==false)
        title=strcat(title, sprintf('(%sClassifiers)', classifiers));
    endif;

    load(dataFile);
    
    assert(exist('p3train', 'var')==1);
    
    decimFactor=p3train.samplingRate/20;
    if(floor(decimFactor)>=2)
        printf('decimation required for signal! \n');
        p3train=downsample(p3train, floor(decimFactor));
        save('-binary', sprintf('../p3data/unknown.%dfold.oct',decimFactor), 'p3train');
    else
        printf('decimation not required \n');
    endif;
    
    if(grouped==true)
        printf('grouping epochs \n');
        p3train=groupEpochs(p3train);
    endif;
    
    %=== FIND THE BEST CLASSIFIER FOR FULL FEATURE SPACE ===
    
    saveFilename=sprintf('~/Forge/p3results/%s-ClassifierGridSearch.oct', title);
    summary1=P3Summary({},{});
    if(~exist(saveFilename, 'file'))
        wf = P3WorkflowClassifierGridSearch(p3train, {@trainTestSplitMx, cvSplits}, classifiers);
        summary1 = launch(wf, 'ClassifierGridSearch');
        %bestClassifier = getBest(summary1);
        
        save('-binary', saveFilename, 'summary1');
    else
        printf('Results file %s already exists. Loading... \n', saveFilename);
        load(saveFilename);
    endif;
    
    gridBestCell=getBest(summary1).trainTest;
    printf('The best classifier after Stage 1: %s \n', stringify(gridBestCell));
    
    
    %=== FIND THE BEST FEATURE SPACE TRANSFORMATION FOR CLASSIFIER FOUND ABOVE ===%
    %wf = P3WorkflowSpaceSearch(p3train, @split...);
    %summary2 = launch(wf, 'FeatureSpaceSearch');
    %bestSpace = getBest(findings_fs, 'featsCompute');
    %bestMask = getBest(findings_fs, 'featsSelect');
    
    %=== FIND OPTIMAL CHANNELS SUBSET FOR THE METHODS DETERMINED ABOVE === %
    
    %a problem arises: need to simultaneously apply two selection methods: channel masking and correlation based
    %wf = P3WorkflowEvaluateChannels(p3train);
    

endfunction;