source batch/batchParams.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

summaries = struct();
[code,out]=system('date +%Y%m%d.%H%M');
summariesSaveFile=sprintf('%s/berlin.summaries_%s.oct', dirSummaries, strtrim(out))

for(dataset = datasets)
    % unpacks the string from a cell
    dataset=dataset{:};
    
    fprintf('Starting batch processing the %s dataset ...', dataset); fflush(stdout);
    summaries.(dataset)=struct();
    
    filename_decim = sprintf('%s%s.%dfold.oct',dirBinaryData, binNames.(dataset), decimationFactor);
    filename_bin = sprintf('%s%s.oct',dirBinaryData, binNames.(dataset));
    
    %check if decimated file already exists
    
    if(exist(filename_decim, 'file')==0)
    
        if(exist(filename_bin, 'file')==0)
            printf('Need to create the binary files.\n');
            convertBerlinData(dirBinaryData, raws.(dataset));
        else
            printf('Decimated does not exist yet, but there is a binary %s.\n', filename_bin);
        endif;
        
        printf('Loading binary file ... ');
        load(filename_bin);
        printf('downsampling ... ');
        p3train = downsample(p3train, decimationFactor);
        p3test = downsample(p3test, decimationFactor);
        printf('saving ... ');
        save('-binary', filename_decim, 'p3train', 'p3test', 'teststring');
        printf('done! \n');
            
    else
        printf('Decimated %s file already exists.\n', filename_decim);
    endif;
    
    % The file should load by now
    load(filename_decim);
    assert(p3train.samplingRate==240/decimationFactor && p3test.samplingRate==240/decimationFactor);
    
    % Create the crossvalidation workflow and ru(i)n it
    xvRate = p3train.periodsCount;
    for(ftr = allfactor(xvRate))
        if(ftr>=minXvRate) xvRate = ftr; break; endif;
    endfor;
    wf=P3WorkflowClassifierGridSearch(P3SessionSplitRepeats(p3train, repeatsSplit), {@trainTestSplitMx, xvRate}, classification_methods, balancing);
    summaries.(dataset).(sprintf('xv%d', xvRate)) = launch(wf);
    save('-binary', summariesSaveFile, 'summaries');
    
    % Labelling data according to the answers provided by competition holders
    p3test = P3SessionAddLabels(p3test, teststring);
    summaries.(dataset).('test') = trainAndTestGrid(p3train, p3test, classification_methods, balancing);
    save('-binary', summariesSaveFile, 'summaries');
    
    % now the same for 'flattened' data
    if(exist('berlinBatchFlattenData','var'))
        fprintf('Flattening the data ...'); fflush(stdout);
        p3train = groupEpochs(p3train);
        p3test = groupEpochs(p3test);
        fprintf('done\n'); fflush(stdout);
    
        wf=P3WorkflowClassifierGridSearch(p3train, {@trainTestSplitMx, xvRate}, classification_methods, balancing);
        summaries.(dataset).(sprintf('flat_xv%d', xvRate)) = launch(wf);
        save('-binary', summariesSaveFile, 'summaries');
        summaries.(dataset).('flat_test') = trainAndTestGrid(p3train, p3test, classification_methods, balancing); 
        save('-binary', summariesSaveFile, 'summaries');
    endif;
endfor;


