function [J, grad] = logRegCostFunction(theta, X, y)
%COSTFUNCTION Compute cost and gradient for logistic regression
%   J = COSTFUNCTION(theta, X, y) computes the cost of using theta as the
%   parameter for logistic regression and the gradient of the cost
%   w.r.t. to the parameters.

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% Note: grad should have the same dimensions as theta

for(i=1:m)
	J+=(  -1*y(i,1)*log(sigmoid(X(i,:)*theta)) - (1-y(i,1))*log(1-sigmoid(X(i,:)*theta))) ;
	grad=grad .+ (X(i,:))'*(sigmoid(X(i,:)*theta)-y(i,1));
end;

J/=size(X,1);
grad/=size(X,1);

endfunction;
