#! /usr/bin/octave -qf

if(~exist('ov_data_path','var'))
	if(length(argv())==1)
		ov_data_path=argv(){1};
	else
		error('ov_data_path variable undefined! Pass it as a command line argument or set before "source" if running from octave.')
	endif;
endif;

warning('off');
pkg load nan;
pkg load signal;

addpath(sprintf('%s/@P3Session', pwd));
addpath(sprintf('%s/@P3Workflow', pwd));
addpath(sprintf('%s/P3Toolkit', pwd));
addpath(sprintf('%s/Classifiers/', pwd));
addpath(sprintf('%s/Classifiers/LogisticRegression', pwd));

p3ov=P3SessionOpenVibe(ov_data_path);

[b,a]=butter(5, [0.1/64, 15/64]);
p3ov=filterEeg(p3ov,b,a);

% p3ov=downsample(p3ov, 4);
p3ov=groupEpochs(p3ov);


%"OBJECT-ORIENTED"
w=P3Workflow(p3ov, @trainTestSplitMx);
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
printf('LR naive: %s\n', confusionMatrixInfo(summary{1}{1}{3}.naive));
printf('LR aware: %s\n', confusionMatrixInfo(summary{1}{1}{3}.aware));



