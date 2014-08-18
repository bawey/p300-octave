function [H, IH] = classifyLogisticRegression(X,Y,eX,eY, MaxIter=400)
	%  Setup the data matrix appropriately, and add ones for the intercept term
	[m, n] = size(X);

	% Add intercept term to x and X_test
	X = [ones(m, 1) X];
	eX= [ones(rows(eX),1) eX];

	% Initialize fitting parameters
	initial_theta = zeros(n + 1, 1);

	% Compute and display initial cost and gradient
	[cost, grad] = logRegCostFunction(initial_theta, X, Y);

	%  Set options for fminunc
	options = optimset('GradObj', 'on', 'MaxIter', MaxIter);

	%  Run fminunc to obtain the optimal theta
	%  This function will return theta and the cost 
	[theta, cost] = fminunc(@(t)(logRegCostFunction(t, X, Y)), initial_theta, options);

	prob = sigmoid(eX * theta);
	% Compute accuracy on our training set
	p = logRegPredict(theta, eX);
	
	
	H=zeros(2,2);
	H(1,1)=sum( eY==0 & p==0 );
	H(1,2)=sum( eY==0 & p==1 );
	H(2,1)=sum( eY==1 & p==0 );
	H(2,2)=sum( eY==1 & p==1 );
	
	ip=zeros(size(p));
	[sorted_value, sorted_index] = sort(prob, 'descend');
	ip(sorted_index(1:2))=1;
	
	IH=zeros(2,2);
	IH(1,1)=sum( eY==0 & ip==0 );
	IH(1,2)=sum( eY==0 & ip==1 );
	IH(2,1)=sum( eY==1 & ip==0 );
	IH(2,2)=sum( eY==1 & ip==1 );
	
endfunction;