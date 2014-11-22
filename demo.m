init();
p3s = P3SessionLobenotion('~/Desktop/eeg/','tomek_session_012');
fflush(stdout);
  p3s2 = P3SessionLobenotion('~/Desktop/eeg/','tomek_session_014');
  fflush(stdout);
  p3s3 = P3SessionLobenotion('~/Desktop/eeg/','tomek_session_015');
  fflush(stdout);
%  
  p3s=P3SessionMerge(p3s, p3s2);
  fflush(stdout);
  p3s=P3SessionMerge(p3s, p3s3);
  fflush(stdout);

cpustart=cputime;
p3sd=downsample(p3s, 6);
fprintf('Decimating trainset took %.3f seconds \n', (cputime-cpustart));

p3sd = P3SessionSplitRepeats(p3sd, 'max');
p3sd = P3SessionSplitRepeats(p3sd, 'max');

[model, tr_mean, tr_std, modelCell, featsMask, featsSelectCell, summary] = pickClassifier(p3sd, 'fast');
%  askClassifier(model, p3sd, tr_mean, tr_std, featsMask);

p3t   =  P3SessionLobenotion('~/Desktop/eeg/','tomek_session_011');
p3t2  =  P3SessionLobenotion('~/Desktop/eeg/','tomek_session_016');
p3t3  =  P3SessionLobenotion('~/Desktop/eeg/','tomek_session_009');
p3t   =  P3SessionMerge(p3t, p3t2);
p3t   =  P3SessionMerge(p3t, p3t3);

cpustart=cputime;
p3td=downsample(p3t, 6);
fprintf('Decimating testset took %.3f seconds \n', (cputime-cpustart));

for(r=0:10)
    fprintf('Reducing repeats-per-stimulus by %d\n', r);
    p3r=P3SessionReduceRepeats(p3td, r);
    askClassifier(model, p3r, tr_mean, tr_std, featsMask);
    fflush(stdout);
endfor;

