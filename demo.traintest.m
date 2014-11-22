p3train_raw = P3SessionLobenotion('~/Desktop/eeg/','tomek_session_016');
p3train = downsample(p3train_raw, 6);

p3test_raw = P3SessionLobenotion('~/Desktop/eeg/','tomek_session_014');
p3test = downsample(p3test_raw, 6);

[feats, labels, stimuli] = classificationData(p3train);
[feats, tr_mean, tr_std] = centerTrainData(feats);


permord=randperm(rows(labels));
labels=labels(permord);
feats=feats(permord, :);

svmbag = BalancedClassifier(feats, labels, {@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',10))});
svm = ClassifierNan(feats, labels, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',10)));

askClassifier(svmbag, p3train, tr_mean, tr_std);
askClassifier(svm, p3train, tr_mean, tr_std);

flda = ClassifierNan(feats, labels, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',10)));
nn = ClassifierNN(feats, labels);

askClassifier(svmbag, p3train, tr_mean, tr_std);
askClassifier(svm, p3train, tr_mean, tr_std);