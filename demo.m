init();
p3s = P3SessionLobenotion('~/Desktop/eeg/','tomek_session_012');

[model, tr_mean, tr_std, modelCell] = pickClassifier(p3s);
askClassifier(model, p3s, tr_mean, tr_std);

p3t = P3SessionLobenotion('~/Desktop/eeg/','tomek_session_011');
askClassifier(model, p3t, tr_mean, tr_std);