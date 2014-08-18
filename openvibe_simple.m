#! /usr/bin/octave -qf
%  This is a reference scenario that loads N periods of data (N spelled characters) and carries out the train-test procedure N times, 
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

[b,a]=butter(5, [0.1/64, 10/64]);
p3ov=filterEeg(p3ov,b,a);

p3ov=groupEpochs(p3ov);
p3ov=downsample(p3ov, 8);


%cells for pretty-printing the summary
fc={}; %Features Computation
fs={}; %Features Selection
cl={}; %CLassification

%BUG!
channelNames=p3ov.channelNames;

%"OBJECT-ORIENTED"
  w=P3Workflow(p3ov, @trainTestSplitMx);
  w=addFunction(w, 'featsCompute', @featsComputePassThrough); fc{end+1}='pass-through';
  w=addFunction(w, 'featsSelect', @featsSelectPassThrough); fs{end+1}='pass-through';
  w=addFunction(w, 'classify', @classifyLDA);	cl{end+1}='LDA';
  w=addFunction(w, 'classify', @classifyFDA); cl{end+1}='FDA';
  w=addFunction(w, 'classify', @classifyLogisticRegression); cl{end+1}='LogReg';
  
  summary=launch(w);
  
  for(x=1:length(summary))
      for(y=1:length(summary{x}))
          for(z=1:length(summary{x}{y}))
              [nfo, stats] = confusionMatrixInfo(summary{x}{y}{z}.naive);
              printf('feats computation: %20s, feats selection: %20s, classifier (naive): %10s , %s\n', fc{x}, fs{y}, cl{z}, nfo);
              [nfo, stats] = confusionMatrixInfo(summary{x}{y}{z}.aware);
              printf('feats computation: %20s, feats selection: %20s, classifier (aware): %10s , %s\n', fc{x}, fs{y}, cl{z}, nfo);
          endfor;
      endfor;
  endfor;