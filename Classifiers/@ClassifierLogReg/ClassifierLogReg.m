%
% ClassifierLogReg(X,Y,MaxIter=400, lambda=1)
%
function classifier = ClassifierLogReg(X,Y,MaxIter=400, lambda=1)

	classfier=struct();
	
	%  Setup the data matrix appropriately, and add ones for the intercept term
	[m, n] = size(X);

	% Add intercept term to x and X_test
	X = [ones(m, 1) X];

	% Initialize fitting parameters
	initial_theta = zeros(n + 1, 1);

	% Compute and display initial cost and gradient
	[cost, grad] = logRegCostFunctionReg(initial_theta, X, Y, lambda);

    fprintf('initial cost of theta: %.3f\n', cost);

	%  Set options for fminunc
	options = optimset('GradObj', 'on', 'MaxIter', MaxIter);

	%  Run fminunc to obtain the optimal theta
	%  This function will return theta and the cost 
	[theta, cost] = fminunc(@(t)(logRegCostFunctionReg(t, X, Y, lambda)), initial_theta, options);
	
	
	fprintf('cost of theta: %.3f\n', cost);

	classifier.theta=theta;
	classifier=class(classifier, 'ClassifierLogReg');
	
endfunction;
	