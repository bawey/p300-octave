function init()
	warning('off');
	pkg load nan;
	pkg load signal;

	addpath(sprintf('%s/@P3Session', pwd));
	addpath(sprintf('%s/@P3Workflow', pwd));
	addpath(sprintf('%s/P3Toolkit', pwd));
	addpath(sprintf('%s/Classifiers/', pwd));
	addpath(sprintf('%s/Classifiers/@ClassifierLogReg', pwd));
	
endfunction;