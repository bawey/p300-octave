%
% ClassifierLogReg(X,Y,MaxIter=400, lambda=1)
%
function classifier = ClassifierLogReg(X,Y,MaxIter=175, lambda=1, stimuli=[], varargin)

	classifier=struct();

    % May the classifier object store data parameters
    
    % Need to allow explicit data adjustment disabling (eg. by a top level aggregate classifier)
    centering = true;
    
    for(i=1:numel(varargin))
        if(isstr(varargin{i}))
            if(strcmp(varargin{i}, 'nocentering'))
                centering=false;
            endif;
        endif;
    endfor;
    
    tr_std = ones(1, columns(X));
    tr_mean = zeros(1, columns(X));
    if(centering)
        [X, tr_mean, tr_std] = centerTrainData(X);    
    endif;
    
    classifier.centering = centering;
%      fprintf('ClassifierLogReg, centering=%d\n', centering);
    classifier.tr_mean = tr_mean;
    classifier.tr_std = tr_std;
    % end of data centering	
    
	%  Setup the data matrix appropriately, and add ones for the intercept term
	[m, n] = size(X);

	% Add intercept term to x and X_test
	X = [ones(m, 1) X];

	% Initialize fitting parameters
	initial_theta = zeros(n + 1, 1);

	% Compute and display initial cost and gradient
	[cost, grad] = logRegCostFunctionReg(initial_theta, X, Y, lambda);

    %fprintf('initial cost of theta: %.3f\n', cost);

	%  Set options for fminunc
	options = optimset('GradObj', 'on', 'MaxIter', MaxIter);

	%  Run fminunc to obtain the optimal theta
	%  This function will return theta and the cost 
	[theta, cost] = fminunc(@(t)(logRegCostFunctionReg(t, X, Y, lambda)), initial_theta, options);
	
	
	%fprintf('cost of theta: %.3f\n', cost);

	classifier.theta=theta;
	classifier=class(classifier, 'ClassifierLogReg');
	
endfunction;
	