init();
p3s = P3SessionLobenotion('~/Desktop/eeg/','tomek_session_011');
p3s = downsample(p3s, 6);

[model, tr_mean, tr_std, modelCell] = pickClassifier(p3s);
askClassifier(model, p3s, tr_mean, tr_std);