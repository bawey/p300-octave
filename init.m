%sets up the paths required for carrying out the experiments
function init()
	warning('off');
	pkg load nan;
	pkg load signal;

	addpath(sprintf('%s/@P3Session', pwd));
	addpath(sprintf('%s/@P3Workflow', pwd));
	addpath(sprintf('%s/@P3Summary', pwd));
	addpath(sprintf('%s/P3Toolkit', pwd));
	addpath(sprintf('%s/Classifiers/', pwd));
	
	addpath(sprintf('%s/Classifiers/@ClassifierLogReg', pwd));
	addpath(sprintf('%s/Classifiers/@ClassifierNan', pwd));
	addpath(sprintf('%s/Classifiers/@ClassifierSVM', pwd));
	addpath(sprintf('%s/Classifiers/@ClassifierNN', pwd));
	addpath(sprintf('%s/Classifiers/@ClassifiersBag', pwd));
	
	addpath(sprintf('%s/test/', pwd));
	addpath(sprintf('%s/../p3results/', pwd));
	
endfunction;