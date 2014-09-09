function [J, grad] = logRegCostFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values

% You need to return the following variables correctly 

%  timestart=cputime;


modelResp=sigmoid(X*theta);
    
J=(-y)'*log(modelResp) - (1-y)'*log(1-modelResp);
grad= ((modelResp - y(:,1))'*X)';


%  printf('looping took %.4f CPU time \n', cputime-timestart);
fflush(stdout);
J+=+ (lambda/2)*sum(theta(2:end,:).^2);
J/=size(X,1);

grad=grad.+[0; theta(2:end).*lambda];
grad/=size(X,1);

%  global lasttime; %'
%  if(lasttime>0)
%  	printf('Execution took %.4f CPU time \n', cputime-lasttime);
%  endif;
%  lasttime=cputime;

% =============================================================

end
