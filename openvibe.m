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
pkg load parallel;

addpath(sprintf('%s/@P3Session', pwd));
addpath(sprintf('%s/@P3Workflow', pwd));
addpath(sprintf('%s/P3Toolkit', pwd));
addpath(sprintf('%s/Classifiers/', pwd));
addpath(sprintf('%s/Classifiers/LogisticRegression', pwd));

p3ov=P3SessionOpenVibe(ov_data_path);

[b,a]=butter(5, [0.1/64, 10/64]);

%  DO NOT RUN THE CODE BEFORE ADDRESSING THE LINE BELOW: CHANGED BEFORE LEAVING TO SEE THE RESULTS OF DECIMATION!
p3ov=filterEeg(p3ov,b,a);
p3ov=groupEpochs(p3ov);
p3ov=downsample(p3ov, 8);


%cells for pretty-printing the summary
fc={}; %Features Computation
fs={}; %Features Selection
cl={}; %CLassification

%"OBJECT-ORIENTED"
w=P3Workflow(p3ov, @trainTestSplitMx);
w=addFunction(w, 'featsCompute', @featsComputePassThrough); fc{end+1}='pass-through';
%w=addFunction(w, 'featsSelect', @featsSelectPassThrough);

%BUG!
channelNames=p3ov.channelNames;

for(ch=1:p3ov.channelsCount)
	w=addFunction(w, 'featsSelect', @featsSelectPickChannels, p3ov.samplesCountPerEpoch, ch);
	fs{end+1}=sprintf('%d. channel only [%s]', ch, channelNames{ch});
endfor;
w=addFunction(w, 'classify', @classifyLDA); cl{end+1}='LDA';
w=addFunction(w, 'classify', @classifyFDA); cl{end+1}='FDA';
w=addFunction(w, 'classify', @classifyLogisticRegression); cl{end+1}='LogReg';

summary=launch(w)

%  printf('LDA naive: %s\n', confusionMatrixInfo(summary{1}{1}{1}.naive));
%  printf('LDA aware: %s\n', confusionMatrixInfo(summary{1}{1}{1}.aware));
%  printf('FDA naive: %s\n', confusionMatrixInfo(summary{1}{1}{2}.naive));
%  printf('FDA aware: %s\n', confusionMatrixInfo(summary{1}{1}{2}.aware));
%  printf('LR naive: %s\n', confusionMatrixInfo(summary{1}{1}{3}.naive));
%  printf('LR aware: %s\n', confusionMatrixInfo(summary{1}{1}{3}.aware));


channel_scores=[];
for(x=1:length(summary))
	for(y=1:length(summary{x}))
		score=0;
		for(z=1:length(summary{x}{y}))
			[nfo, stats] = confusionMatrixInfo(summary{x}{y}{z}.naive);
			printf('feats computation: %20s, feats selection: %20s, classifier (naive): %10s , %s', fc{x}, fs{y}, cl{z}, nfo);
			subscore=(stats.recall+stats.precision)/2;
			[nfo, stats] = confusionMatrixInfo(summary{x}{y}{z}.aware);
			%subscore is the better of two averages of precision and recal: either for he aware or for the naive classifier
			printf('feats computation: %20s, feats selection: %20s, classifier (aware): %10s , %s', fc{x}, fs{y}, cl{z}, nfo);
			subscore=max(score, (stats.recall+stats.precision)/2);
			%score for the channel is the best classification subscore for that channel
			score=max(score, subscore);
		endfor;
		channel_scores=[channel_scores; score];
	endfor;
endfor;

%remove all the single-channel selecting code and corrresponding printouts
w=clearFunctions(w, 'featsSelect');
fs={};

[cs, cn] = sort(channel_scores, 'descend');
channels_score=[cs, cn];

printf('============ Results for single chanel based classifiers  ============\n');
for(i=1:size(channels_score,1))
printf('#%2d. channel %3d [%5s] (score: %.2f) \n', i, channels_score(i,2), channelNames{channels_score(i,2)}, channels_score(i,1));
endfor;
printf('============++++++++++++++++++++++++++++++++++++++++++++++============\n');

for(i=2:size(channels_score,1))
	%pick the 'best' channels from 1 to i
	channels=channels_score(1:i,2)';
	w=addFunction(w, 'featsSelect', @featsSelectPickChannels, p3ov.samplesCountPerEpoch, channels);
	fs{end+1}=sprintf('channels %30s [%30s]', mat2str(channels), strcat(channelNames{channels}));
endfor;

summary2=launch(w);


for(x=1:length(summary2))

for(y=1:length(summary2{x}))

score=0;
for(z=1:length(summary2{x}{y}))

[nfo, stats] = confusionMatrixInfo(summary2{x}{y}{z}.naive);
printf('feats computation: %15s, feats selection: %20s, classifier (naive): %10s , %s', fc{x}, fs{y}, cl{z}, nfo);

[nfo, stats] = confusionMatrixInfo(summary2{x}{y}{z}.aware);
printf('feats computation: %15s, feats selection: %20s, classifier (aware): %10s , %s', fc{x}, fs{y}, cl{z}, nfo);

endfor;

endfor;

endfor;