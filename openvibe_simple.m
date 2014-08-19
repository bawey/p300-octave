#! /usr/bin/octave -qf
%  This is a reference scenario that loads N periods of data (N spelled characters) and carries out the train-test procedure N times, 

init();

if(~exist('ov_data_path','var'))
	if(length(argv())==1)
		ov_data_path=argv(){1};
	else
		error('ov_data_path variable undefined! Pass it as a command line argument or set before "source" if running from octave.')
	endif;
endif;



p3ov=P3SessionOpenVibe(ov_data_path);

[b,a]=butter(5, [0.1/64, 10/64]);
p3ov=filterEeg(p3ov,b,a);

p3ov=groupEpochs(p3ov);
p3ov=downsample(p3ov, 8);


%cells for pretty-printing the summary
fc={}; %Features Computation
fs={}; %Features Selection
tt={}; %CLassification

%BUG!
channelNames=p3ov.channelNames;

%"OBJECT-ORIENTED"
w=P3Workflow(p3ov, @trainTestSplitMx);
w=addFunction(w, 'featsCompute', @featsComputePassThrough); fc{end+1}='pass-through';
w=addFunction(w, 'featsSelect', @featsSelectPassThrough); fs{end+1}='pass-through';
w=addFunction(w, 'trainTest', @ttLDA);	tt{end+1}='LDA';
w=addFunction(w, 'trainTest', @ttFDA); tt{end+1}='FDA';
w=addFunction(w, 'trainTest', @ttLogisticRegression); tt{end+1}='LogReg';
  
summary=launch(w);
  
summarize(summary, fc, fs, tt);