% The aim here is to find a classifier for data from a session taken on given day and compare classifiers performance against other data from that very day against some data from a different day.
eeg_dir = '~/Desktop/eeg';

%data taken on the same day
p3tr = P3SessionLobenotion(eeg_dir, 'tomek_session_016');
p3tr = P3SessionMerge(P3SessionLobenotion(eeg_dir, 'tomek_session_014'), p3tr);

% we will use sessions 12 and 17 for test. 17 also had a 1 or 2 noisy electrodes
p3te1 = P3SessionLobenotion(eeg_dir, 'tomek_session_012'); 
p3te2 = P3SessionLobenotion(eeg_dir, 'tomek_session_017');
% session 15 dates to the same day as train sessions
p3te3 = P3SessionLobenotion(eeg_dir, 'tomek_session_015');

[xs_model, xs_tr_mean, xs_tr_std, modelCell, featsMask, featsSelectCell, summary] = pickClassifier(p3tr, 'fast');

askClassifier(xs_model, p3te3, xs_tr_mean, xs_tr_std);

askClassifier(xs_model, p3te1, xs_tr_mean, xs_tr_std);

askClassifier(xs_model, p3te2, xs_tr_mean, xs_tr_std);