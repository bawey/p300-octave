#! /usr/bin/octave -qf

init();

if(length(argv())==1)
	berlin_data_path=argv(){1};
elseif(~exist('berlin_data_path','var'))
	error('berlin_data_path variable undefined! Pass it as a command line argument or set before "source" if running from octave.')
endif;

filenames={'AAS010R01.mat','AAS010R02.mat','AAS010R03.mat','AAS010R04.mat'};
for(i=1:length(filenames))
	filenames{i}=sprintf('%s/%s',berlin_data_path, filenames{i});
endfor;

filenames{:}

p3 = P3SessionBerlin(filenames{:});

p3=groupEpochs(p3);
[b,a]=butter(5, [0.1/120, 15/120]);
p3=filterEeg(p3,b,a);

p3=downsample(p3, 6);

%some structures for pretty printing
fc={};
fs={};
cl={};

%"OBJECT-ORIENTED"
w=P3Workflow(p3, @trainTestSplitMx);
w=addFunction(w, 'featsCompute', 	@featsComputePassThrough); 		fc{end+1}='pass-through';
w=addFunction(w, 'featsSelect', 	@featsSelectPassThrough);		fs{end+1}='pass-through';
w=addFunction(w, 'classify', 		@classifyLDA);					cl{end+1}='LDA';
w=addFunction(w, 'classify', 		@classifyFDA);					cl{end+1}='FDA';
w=addFunction(w, 'classify', 		@classifyLogisticRegression);	cl{end+1}='LogReg';

summary=launch(w);

summary2str(summary, fc, fs, cl);