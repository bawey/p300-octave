% Available sessions look more less like this: 
%  -rw-rw-r-- 1 bawey bawey  98 nov.  22 21:47 tomek_session_017_summary   phrase: BADSIGNAL
%  -rw-rw-r-- 1 bawey bawey  96 nov.  19 16:21 tomek_session_014_summary   phrase: HAPPINESS
%  -rw-rw-r-- 1 bawey bawey  95 nov.  19 15:41 tomek_session_016_summary   phrase: OCTAVE
%  -rw-rw-r-- 1 bawey bawey  98 nov.  19 15:29 tomek_session_015_summary   phrase: VALENTINA
%  -rw-rw-r-- 1 bawey bawey 100 nov.  17 12:16 tomek_session_009_summary   phrase: EQUALITY
%  -rw-rw-r-- 1 bawey bawey  92 nov.  17 12:16 tomek_session_011_summary   phrase: TEST
%  -rw-rw-r-- 1 bawey bawey 100 nov.  17 12:16 tomek_session_012_summary   phrase: EMANCIPATION

%   buckets
%   %SAME_DAY_1:    train: TEST, EQUALITY           test: EMANCIPATION
%   %SAME_DAY_2:    train: VALENTINA, OCTAVE        test: HAPPINESS
%   %MIXED_1:         train: EMANCIPATION, HAPPINESS, test: OCTAVE, VALENTINA, EQUALITY, TEST   
%   %MIXED_2:         train: EMANCIPATION, HAPPINESS, test: BADSIGNAL, OCTAVE, VALENTINA, EQUALITY, TEST   

eeg_dir = '~/Desktop/eeg/';

% BUCKET 1
b1_p3_tr = P3SessionMerge(P3SessionLobenotion(eeg_dir,'tomek_session_011'), P3SessionLobenotion(eeg_dir,'tomek_session_009'));
b1_p3_te = P3SessionLobenotion(eeg_dir,'tomek_session_012');

[b1_model b1_modelCell b1_featsSelectCell b1_summary] = pickClassifier(b1_p3_tr, 'all', 'no');
b1_scores = trainTestMesh(b1_p3_tr, b1_p3_te, b1_modelCell);


% BUCKET 2
b2_p3_tr = P3SessionMerge(P3SessionLobenotion(eeg_dir,'tomek_session_015'),P3SessionLobenotion(eeg_dir,'tomek_session_016'));
b2_p3_te = P3SessionLobenotion(eeg_dir,'tomek_session_014');

[b2_model b2_modelCell b2_featsSelectCell b2_summary] = pickClassifier(b2_p3_tr, 'all', 'no');
b2_scores = trainTestMesh(b2_p3_tr, b2_p3_te, b2_modelCell);


% BUCKET 3
b3_p3_tr = P3SessionMerge(P3SessionLobenotion(eeg_dir,'tomek_session_014'),P3SessionLobenotion(eeg_dir,'tomek_session_012'));
b3_p3_te = P3SessionMerge(
                P3SessionMerge(P3SessionLobenotion(eeg_dir,'tomek_session_016'),P3SessionLobenotion(eeg_dir,'tomek_session_015')),
                P3SessionMerge(P3SessionLobenotion(eeg_dir,'tomek_session_012'),P3SessionLobenotion(eeg_dir,'tomek_session_011'))
            );

[b3_model b3_modelCell b3_featsSelectCell b3_summary] = pickClassifier(b3_p3_tr, 'all', 'no');
b3_scores = trainTestMesh(b3_p3_tr, b3_p3_te, b3_modelCell);

% BUCKET 4
b4_p3_te = P3SessionLobenotion(eeg_dir,'tomek_session_017');

%[b4_model b4_modelCell b4_featsSelectCell b4_summary] = pickClassifier(b4_p3_tr, 'all', 'no');
b4_scores = trainTestMesh(b3_p3_tr, b4_p3_te, b3_modelCell);

%save all the variables into a binary file
save('-binary', sprintf('%s/demoSameDayPerformance.oct', eeg_dir));