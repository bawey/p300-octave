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

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta
%
% Note: grad should have the same dimensions as theta
%
#size(theta) = 3 1
#size(X) = 100 3
#size(y) = 100 1
for(i=1:m)
	J+=(  -1*y(i,1)*log(sigmoid(X(i,:)*theta)) - (1-y(i,1))*log(1-sigmoid(X(i,:)*theta))) ;
	grad=grad .+ (X(i,:))'*(sigmoid(X(i,:)*theta)-y(i,1));
end;

J/=size(X,1);
grad/=size(X,1);







% =============================================================

end
