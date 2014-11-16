% This one aims to aggregate several classifiers so that each would have the same amount of positive and negative samples
% Answering will probably be by averaging.
%
function classifier = BalancedClassifier(X, y, classifierCell)
    classifier.units={}';

    minors = find(y==1);
    majors = find(y~=1);

    majorsOrdering = randperm(length(majors));

    for(start = 0 : length(minors) : length(majors)-1)
    	finish=start+length(minors);
    	start = start+1;

%      	printf('Current compartment starts at %d and ends at %d sample of %d major class samples\n', start, finish, length(majors));

    	%we need all the minors paired with equal amount of majors
    	samplesSelector = [minors; majors(majorsOrdering(start:finish))];

%      	printf('First step. Samples selector of length %d \n', length(samplesSelector)); fflush(stdout);

    	% samplesSelector = samplesSelector(randperm(length(samplesSelector)));

    	sX = X(samplesSelector, :);
    	sy = y(samplesSelector, :);

%      	printf('About to train a classifier on %d samples, %d of which positive, %d negative. \n', length(sy), length(find(sy==1)), length(find(sy==0))); fflush(stdout);

    	tic
    	classifier.units{end+1}=feval(classifierCell{1}, sX, sy, classifierCell{[1:end]~=1});
    	toc
    endfor;
    classifier=class(classifier, 'BalancedClassifier');
endfunction;