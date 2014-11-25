%  -rw-rw-r-- 1 bawey bawey  98 nov.  22 21:47 tomek_session_017_summary   phrase: BADSIGNAL
%  -rw-rw-r-- 1 bawey bawey  96 nov.  19 16:21 tomek_session_014_summary   phrase: HAPPINESS
%  -rw-rw-r-- 1 bawey bawey  95 nov.  19 15:41 tomek_session_016_summary   phrase: OCTAVE
%  -rw-rw-r-- 1 bawey bawey  98 nov.  19 15:29 tomek_session_015_summary   phrase: VALENTINA
%  -rw-rw-r-- 1 bawey bawey 100 nov.  17 12:16 tomek_session_009_summary   phrase: EQUALITY
%  -rw-rw-r-- 1 bawey bawey  92 nov.  17 12:16 tomek_session_011_summary   phrase: TEST
%  -rw-rw-r-- 1 bawey bawey 100 nov.  17 12:16 tomek_session_012_summary   phrase: EMANCIPATION

eeg_dir = '~/Desktop/eeg';
eeg_file_stem = 'tomek_session_';

trains=[9 11 12 15 16 17]
tests=[14];

p3tr=P3SessionLobenotion(eeg_dir, sprintf('%s%03d', eeg_file_stem, trains(1)));
for(i=trains(2:end))
    p3tr = P3SessionMerge(p3tr, P3SessionLobenotion(eeg_dir, sprintf('%s%03d', eeg_file_stem, i)));
endfor;

p3te=P3SessionLobenotion(eeg_dir, sprintf('%s%03d', eeg_file_stem, tests(1)));

[model modelCell featsSelectCell summary] = pickClassifier(p3tr, 'fast', 'no');

scores=trainTestMesh(p3tr, p3te, modelCell);