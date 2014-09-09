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

modelResp=sigmoid(X*theta);
    
J=(-y)'*log(modelResp) - (1-y)'*log(1-modelResp);
grad= ((modelResp - y(:,1))'*X)';

J/=size(X,1);
grad/=size(X,1);

endfunction;
