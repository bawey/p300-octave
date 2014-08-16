#! /usr/bin/octave -qf

if(length(argv())==1)
	berlin_data_path=argv(){1};
elseif(~exist('berlin_data_path','var'))
	error('berlin_data_path variable undefined! Pass it as a command line argument or set before "source" if running from octave.')
endif;

warning('off');
pkg load nan;
pkg load signal;

addpath(sprintf('%s/@P3Session', pwd));
addpath(sprintf('%s/@P3Workflow', pwd));
addpath(sprintf('%s/P3Toolkit', pwd));
addpath(sprintf('%s/Classifiers/', pwd));
addpath(sprintf('%s/Classifiers/LogisticRegression', pwd));
%  warning('on');

filenames={'AAS010R01.mat','AAS010R02.mat','AAS010R03.mat','AAS010R04.mat'};
for(i=1:length(filenames))
	filenames{i}=sprintf('%s/%s',berlin_data_path, filenames{i});
endfor;

filenames{:}

p3 = P3SessionBerlin(filenames{:});

[b,a]=butter(5, [0.1/120, 15/120]);
p3=filterEeg(p3,b,a);

p3=downsample(p3, 6);
p3=groupEpochs(p3);


%"OBJECT-ORIENTED"

w=P3Workflow(p3, @trainTestSplitMx);
w=addFunction(w, 'featsCompute', @featsComputePassThrough);
w=addFunction(w, 'featsSelect', @featsSelectPassThrough);
w=addFunction(w, 'classify', @classifyLDA);
w=addFunction(w, 'classify', @classifyFDA);
w=addFunction(w, 'classify', @classifyLogisticRegression);

summary=launch(w)

printf('LDA naive: %s\n', confusionMatrixInfo(summary{1}{1}{1}.naive));
printf('LDA aware: %s\n', confusionMatrixInfo(summary{1}{1}{1}.aware));
printf('FDA naive: %s\n', confusionMatrixInfo(summary{1}{1}{2}.naive));
printf('FDA aware: %s\n', confusionMatrixInfo(summary{1}{1}{2}.aware));
printf('LR	naive: %s\n', confusionMatrixInfo(summary{1}{1}{3}.naive));
printf('LR 	aware: %s\n', confusionMatrixInfo(summary{1}{1}{3}.aware));