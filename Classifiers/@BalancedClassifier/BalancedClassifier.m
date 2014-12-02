% This one aims to aggregate several classifiers so that each would have the same amount of positive and negative samples
% Answering will probably be by averaging.
%
function classifier = BalancedClassifier(X, y, classifierCell, varargin)
    
    % Need to allow explicit data adjustment disabling (eg. from the P3Workflow.launch method that might perform the centering once for all the classifiers being trained)
    centering = true;
    voting = true;
    
    for(i=1:numel(varargin))
        if(isstr(varargin{i}))
            if(strcmp(varargin{i}, 'nocentering'))
                centering=false;
            endif;
            if(strcmp(varargin{i}, 'novoting'))
                voting=false;
            endif;
        endif;
    endfor;
    
    tr_std = ones(1, columns(X));
    tr_mean = zeros(1, columns(X));
    if(centering)
        [X, tr_mean, tr_std] = centerTrainData(X);    
    endif;
    
    classifier.centering = centering;
    classifier.voting = voting;
%      fprintf('BalancedClassifier, centering=%d\n', centering);
    classifier.tr_mean = tr_mean;
    classifier.tr_std = tr_std;
    
    classifier.units={}';

    minors = find(y==1);
    majors = find(y~=1);

%      majorsOrdering = randperm(length(majors));
    majorsOrdering = [1:length(majors)];

    for(start = 0 : length(minors) : length(majors)-1)
    	finish=start+length(minors);
    	start = start+1;

%     	printf('Current compartment starts at %d and ends at %d sample of %d major class samples. It also contains %d minor examples.\n', start, finish, length(majors), length(minors));

    	%we need all the minors paired with equal amount of majors
    	
    	samplesSelector = [minors; majors(majorsOrdering(start:finish))];

%      	printf('First step. Samples selector of length %d \n', length(samplesSelector)); fflush(stdout);

    	% Randomization makes the results unpredictable and the classifier itself ultimately worse
        % samplesSelector = samplesSelector(randperm(numel(samplesSelector)));
    	sX = X(samplesSelector, :);
    	sy = y(samplesSelector, :);
    	

%      	printf('About to train a classifier on %d samples, %d of which positive, %d negative. \n', length(sy), length(find(sy==1)), length(find(sy==0))); fflush(stdout);
    	classifier.units{end+1}=feval(classifierCell{1}, sX, sy, classifierCell{[1:end]~=1}, [], 'nocentering');
    	
    endfor;
    classifier=class(classifier, 'BalancedClassifier');
endfunction;