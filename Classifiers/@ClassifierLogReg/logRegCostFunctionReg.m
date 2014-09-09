function [J, grad] = logRegCostFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta

#size(theta) = 3 1
#size(X) = 100 3
#size(y) = 100 1
timestart=cputime;


J+=(y.*-1)'*log(sigmoid(X))*theta - (1-y)'*log(sigmoid(X))*theta;
grad=  X'* ((sigmoid(X)*theta)  -y(:,1));


printf('looping took %.4f CPU time \n', cputime-timestart);
fflush(stdout);
J+=+ (lambda/2)*sum(theta(2:end,:).^2);
J/=size(X,1);

grad=grad.+[0; theta(2:end).*lambda];
grad/=size(X,1);

global lasttime; %'
if(lasttime>0)
	printf('Execution took %.4f CPU time \n', cputime-lasttime);
endif;
lasttime=cputime;

% =============================================================

end
