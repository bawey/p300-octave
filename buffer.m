%Wczytaj dane Berlin BCI II
load ~/Desktop/p3tt-berlin2.12fold.oct

%Uśrednij dane 
p3train_g=groupEpochs(p3train);
p3test_g=groupEpochs(p3test);

st1_grouped={};
st1_loose={};
[st1_grouped.summary, st1_grouped.fc, st1_grouped.fs, st1_grouped.tt, st1_grouped.title]=experimentCompareClassifiers(p3train_g, 'Berlin2.Grouped.Stage1', 21);
[st1_loose.summary, st1_loose.fc, st1_loose.fs, st1_loose.tt, st1_loose.title]=experimentCompareClassifiers(p3train, 'Berlin2.Loose.Stage1', 21);


%Natępnie można coś wypróbować pomajsterkować z przestrzenią cech wybranego rozwiązania 

%najpierw dla uśrednionych ======================================
p3w=P3Workflow(p3train_g, @trainTestSplitMx, {21});
% 'wyszlo' SVM z 0.1 i LogReg z 1
tt={}
lambda = 1; c=0.1; maxIter=150;

%  p3w=addFunction(p3w, 'trainTest', @ClassifierLogReg, maxIter, lambda);
%  tt{end+1}=sprintf('LogReg (lambda=%.3f, maxIter=%d)',lambda, maxIter);

p3w=addFunction(p3w, 'trainTest', @ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',c)));
tt{end+1}=sprintf('linear SVM (c=%.3f)',c);

st2_grouped={};
[st2_grouped.summary, st2_grouped.fc, st2_grouped.fs, st2_grouped.tt, st2_grouped.title]=experimentTuneFeatureSpace(p3w, tt, 'Berlin2.Grouped.Stage2.SVM.oct', 21);
% ===================================================================

p3w=P3Workflow(p3train, @trainTestSplitMx, {21});
% 'wyszlo' SVM z 1
tt={}
c=1;

p3w=addFunction(p3w, 'trainTest', @ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',c)));
tt{end+1}=sprintf('linear SVM (c=%.3f)',c);

s2_loose={};
[st2_loose.summary, st2_loose.fc, st2_loose.fs, st2_loose.tt, st2_loose.title]=experimentTuneFeatureSpace(p3w, tt, 'Berlin2.Loose.Stage2.SVM', 21);
%


%znalazłszy rozwiązanie, testujemy na zbiorze testowym
testBerlin(p3train, p3test, teststring, {@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',.1))}, {@featsComputePCAWithKSR,0.1});
testBerlin(p3train_g, p3test_g, teststring, {@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',.1))}, {@featsComputePassThrough}, {@featsSelectFss, 0.05});


% =============================== BERLIN III A====================================================
%Wczytaj dane Berlin BCI II
load /stuff/eeg.pristine/p3tt-berlin3a.12fold.oct

%Uśrednij dane 
p3train_g=groupEpochs(p3train);
p3test_g=groupEpochs(p3test);

st1_grouped={};
st1_loose={};
[st1_grouped.summary, st1_grouped.fc, st1_grouped.fs, st1_grouped.tt, st1_grouped.title]=experimentCompareClassifiers(p3train_g, 'Berlin3a.Grouped.Stage1', 17);
[st1_loose.summary, st1_loose.fc, st1_loose.fs, st1_loose.tt, st1_loose.title]=experimentCompareClassifiers(p3train, 'Berlin3a.Loose.Stage1', 17);




%Natępnie można coś wypróbować pomajsterkować z przestrzenią cech wybranego rozwiązania 

%najpierw dla uśrednionych ======================================
p3w=P3Workflow(p3train_g, @trainTestSplitMx, {17});
tt={}


%  c=0.1;
%  p3w=addFunction(p3w, 'trainTest', @ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',c)));
%  tt{end+1}=sprintf('linear SVM (c=%.3f)',c);

st2_grouped={};
[st2_grouped.summary, st2_grouped.fc, st2_grouped.fs, st2_grouped.tt, st2_grouped.title]=experimentTuneFeatureSpace(p3w, tt, 'Berlin3a.Grouped.Stage2.---', 17);
% ===================================================================

p3w=P3Workflow(p3train, @trainTestSplitMx, {17});
tt={}

%  c=1;
%  p3w=addFunction(p3w, 'trainTest', @ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',c)));
%  tt{end+1}=sprintf('linear SVM (c=%.3f)',c);

s2_loose={};
[st2_loose.summary, st2_loose.fc, st2_loose.fs, st2_loose.tt, st2_loose.title]=experimentTuneFeatureSpace(p3w, tt, 'Berlin3a.Loose.Stage2.---', 17);
%


%znalazłszy rozwiązanie, testujemy na zbiorze testowym
%  testBerlin(p3train, p3test, teststring, {@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',.1))}, {@featsComputePCAWithKSR,0.1});
%  testBerlin(p3train_g, p3test_g, teststring, {@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',.1))}, {@featsComputePassThrough}, {@featsSelectFss, 0.05});







% =============================== BERLIN III A====================================================
%Wczytaj dane Berlin BCI II
load /stuff/eeg.pristine/p3tt-berlin3b.12fold.oct

%Uśrednij dane 
p3train_g=groupEpochs(p3train);
p3test_g=groupEpochs(p3test);

st1_grouped={};
st1_loose={};
[st1_grouped.summary, st1_grouped.fc, st1_grouped.fs, st1_grouped.tt, st1_grouped.title]=experimentCompareClassifiers(p3train_g, 'Berlin3b.Grouped.Stage1', 17);
[st1_loose.summary, st1_loose.fc, st1_loose.fs, st1_loose.tt, st1_loose.title]=experimentCompareClassifiers(p3train, 'Berlin3b.Loose.Stage1', 17);


%Natępnie można coś wypróbować pomajsterkować z przestrzenią cech wybranego rozwiązania 

%najpierw dla uśrednionych ======================================
p3w=P3Workflow(p3train_g, @trainTestSplitMx, {17});

tt={}

%  c=0.1;
%  p3w=addFunction(p3w, 'trainTest', @ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',c)));
%  tt{end+1}=sprintf('linear SVM (c=%.3f)',c);

st2_grouped={};
[st2_grouped.summary, st2_grouped.fc, st2_grouped.fs, st2_grouped.tt, st2_grouped.title]=experimentTuneFeatureSpace(p3w, tt, 'Berlin3b.Grouped.Stage2.---', 17);
% ===================================================================

p3w=P3Workflow(p3train, @trainTestSplitMx, {17});

tt={}

%  c=1;
%  p3w=addFunction(p3w, 'trainTest', @ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',c)));
%  tt{end+1}=sprintf('linear SVM (c=%.3f)',c);

s2_loose={};
[st2_loose.summary, st2_loose.fc, st2_loose.fs, st2_loose.tt, st2_loose.title]=experimentTuneFeatureSpace(p3w, tt, 'Berlin3b.Loose.Stage2---', 17);
%


%znalazłszy rozwiązanie, testujemy na zbiorze testowym
%  testBerlin(p3train, p3test, teststring, {@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',.1))}, {@featsComputePCAWithKSR,0.1});
%  testBerlin(p3train_g, p3test_g, teststring, {@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',.1))}, {@featsComputePassThrough}, {@featsSelectFss, 0.05});

