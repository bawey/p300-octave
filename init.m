%sets up the paths required for carrying out the experiments
function init()
	warning('off');
	pkg load nan;
	pkg load signal;
	
	fprintf('Scripts picked up, initialization begins.\n');

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
	addpath(sprintf('%s/Classifiers/@BalancedClassifier', pwd));
	addpath(sprintf('%s/Classifiers/@DummyClassifier', pwd));
	
	addpath(sprintf('%s/test/', pwd));
	
	if(exist('%s/../p3results/')==7)
            addpath(sprintf('%s/../p3results/', pwd));
        endif;
        if (exist('%s/../p3data/')==7)
            addpath(sprintf('%s/../p3data/', pwd));
	endif;
	if(exist('%s/../p3results_balanced/')==7)
            addpath(sprintf('%s/../p3results_balanced', pwd));
        endif;
	
	addpath(sprintf('%s/EpocDemos/', pwd));
	addpath(sprintf('%s/batch/', pwd));
	addpath(sprintf('%s/ClassifiersConfigs/', pwd));
	
endfunction;