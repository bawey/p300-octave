eeg_dir = '~/Desktop/eeg';
eeg_file_stem = 'tomek_session_';
%% AVAILABLE SESSIONS:
b1_trains = [10, 21];
b1_tests = [13, 20, 22, 23, 24];

b2_trains=b1_trains;
b2_tests=[9,11,12,14,15,16,17];

b3_trains = b2_tests;
b3_tests=[b1_trains, b1_tests];

results=struct;

for(b = {'b1', 'b2', 'b3'})
    b=b{:};
    trains = eval(sprintf('%s_trains', b));
    tests = eval(sprintf('%s_tests', b));
    
    p3tr=P3SessionLobenotion(eeg_dir, sprintf('%s%03d', eeg_file_stem, trains(1)));
    for(i=trains(2:end))
        p3tr = P3SessionMerge(p3tr, P3SessionLobenotion(eeg_dir, sprintf('%s%03d', eeg_file_stem, i)));
    endfor;
    
    p3te=P3SessionLobenotion(eeg_dir, sprintf('%s%03d', eeg_file_stem, tests(1)));
    for(i=tests(2:end))
        p3te = P3SessionMerge(p3te, P3SessionLobenotion(eeg_dir, sprintf('%s%03d', eeg_file_stem, i)));
    endfor;

    p3tr=downsample(p3tr, 6);
    p3te=downsample(p3te, 6);

    [model modelCell featsSelectCell summary] = pickClassifier(p3tr, 'all', 'no', 'no', 10);
    scores=trainTestMesh(p3tr, p3te, modelCell)
    
    results.(sprintf('%s_scores', b))=scores;
    results.(sprintf('%s_model', b))=model;
    results.(sprintf('%s_modelCell', b))=modelCell;
    results.(sprintf('%s_summary', b))=summary;
    
endfor;