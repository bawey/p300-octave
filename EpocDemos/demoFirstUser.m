eeg_dir = '~/Desktop/eeg';
eeg_file_stem = 'tomek_session_';
%% AVAILABLE SESSIONS:

% some issues happened when recording the first phrase. let's try the other way round
b1_trains = [13, 21, 22];
b1_tests = [10, 20, 23, 24];

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

    p3tr=downsample(p3tr, 8);
    p3te=downsample(p3te, 8);

    results.(sprintf('%s_p3te', b))=p3te;
    %b2 will reuse the model found in b1
    if(strcmp(b, 'b2')==false)
        [model modelCell featsSelectCell summary] = pickClassifier(p3tr, 'all', 3, 'no', 10);
        [scores, confidence] = trainTestMesh(p3tr, p3te, modelCell);
    
        results.(sprintf('%s_scores', b))=scores;
        results.(sprintf('%s_model', b))=model;
        results.(sprintf('%s_modelCell', b))=modelCell;
        results.(sprintf('%s_summary', b))=summary;
        results.(sprintf('%s_confidence', b))=confidence;
        
        results.(sprintf('%s_p3tr', b))=p3tr;
    else
        [scores, confidence] = trainTestMesh(p3tr, p3te, results.b1_modelCell);
        results.(sprintf('%s_scores', b))=scores;
        results.(sprintf('%s_confidence', b))=confidence;
    endif;
    
endfor;

% extra part: use the accumulated classifier against test data from first point

p3tr=P3SessionLobenotion(eeg_dir, sprintf('%s%03d', eeg_file_stem, b3_trains(1)));
for(i=b3_trains(2:end))
    p3tr = P3SessionMerge(p3tr, P3SessionLobenotion(eeg_dir, sprintf('%s%03d', eeg_file_stem, i)));
endfor;
    
p3te=P3SessionLobenotion(eeg_dir, sprintf('%s%03d', eeg_file_stem, b1_tests(1)));
    for(i=b1_tests(2:end))
    p3te = P3SessionMerge(p3te, P3SessionLobenotion(eeg_dir, sprintf('%s%03d', eeg_file_stem, i)));
endfor;

p3tr=downsample(p3tr, 8);
p3te=downsample(p3te, 8);

[results.b3_b1_scores, results.b3_b1_confidence] = trainTestMesh(p3tr, p3te, results.b3_modelCell);

% Extending with a bit of confidence-involving experiments

results.b1_gaps = getConfGaps(results.b1_p3tr, results.b1_modelCell);
results.b3_gaps = getConfGaps(results.b3_p3tr, results.b3_modelCell);

results.risks = [0.01:0.07:0.99];

for(b = {'b1', 'b2', 'b3'})
    b=b{:};
    avgFlashes = [];
    accuracies= [];
    
    readToken = b;
    if(strcmp('b2', b)) readToken = 'b1'; endif;
    
    gaps = results.(sprintf('%s_gaps',readToken));
    model = results.(sprintf('%s_model',readToken));
    p3te = results.(sprintf('%s_p3te',b));
    
    for(risk = results.risks)
        [minCnf, minReps] = pickConfidence(gaps, risk);
        [out conf flashesUsed accuracy] = askAndConfide(model, p3te, minCnf, minReps);
        avgFlashes = [avgFlashes; mean(flashesUsed)];
        accuracies = [accuracies; accuracy];
    endfor;
    
    results.(sprintf('%s_cnfImpact', b)) = [results.risks', avgFlashes, accuracies];
endfor;

% save all the results
save('-binary', sprintf('%s/epocXp.adhoc.decim8ted.oct', eeg_dir), 'results');