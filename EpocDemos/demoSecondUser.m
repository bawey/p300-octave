eeg_dir = '~/Desktop/eeg';
eeg_file_stem = 'valya_session_';

%% AVAILABLE SESSIONS:
trains = [0];
tests = [1, 2, 3];

p3tr=P3SessionLobenotion(eeg_dir, sprintf('%s%03d', eeg_file_stem, trains(1)));
for(i=trains([1:end]~=1))
    p3tr = P3SessionMerge(p3tr, P3SessionLobenotion(eeg_dir, sprintf('%s%03d', eeg_file_stem, i)));
endfor;
    
p3te=P3SessionLobenotion(eeg_dir, sprintf('%s%03d', eeg_file_stem, tests(1)));
for(i=tests([1:end]~=1))
    p3te = P3SessionMerge(p3te, P3SessionLobenotion(eeg_dir, sprintf('%s%03d', eeg_file_stem, i)));
endfor;

p3tr=downsample(p3tr, 6);
p3te=downsample(p3te, 6);

[model modelCell featsSelectCell summary] = pickClassifier(p3tr, 'all', 'no', 'no', 6);
[scores, confidence]=trainTestMesh(p3tr, p3te, modelCell);

results=struct();

results.model       = model;
results.modelCell   = modelCell;
results.summary     = summary;
results.scores      = scores
results.confidence  = confidence;

save('-binary', sprintf('%s/epocXp2nduser.oct', eeg_dir), 'results');
