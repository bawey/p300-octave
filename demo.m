init();
p3s = P3SessionLobenotion('~/Desktop/eeg/','tomek_session_012');

p3s2 = P3SessionLobenotion('~/Desktop/eeg/','tomek_session_014');

p3s3 = P3SessionLobenotion('~/Desktop/eeg/','tomek_session_015');

p3s=P3SessionMerge(p3s, p3s2);
p3s=P3SessionMerge(p3s, p3s3);

p3s=downsample(p3s, 6);

[model, tr_mean, tr_std, modelCell] = pickClassifier(p3s);
askClassifier(model, p3s, tr_mean, tr_std);

p3t = P3SessionLobenotion('~/Desktop/eeg/','tomek_session_011');
p3t2 = P3SessionLobenotion('~/Desktop/eeg/','tomek_session_016');
p3t=P3SessionMerge(p3t, p3t2);

p3t=downsample(p3t, 6);

for(r=0:10)
    fprintf('Reducing repeats-per-stimulus by %d\n', r);
    p3r=P3SessionReduceRepeats(p3t, r);
    askClassifier(model, p3r, tr_mean, tr_std);
endfor;

