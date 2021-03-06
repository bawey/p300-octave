function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));


    first=sigmoid([ones(size(X,1),1),X]*Theta1');
    second = sigmoid([ones(size(first,1),1),first]*Theta2');


    first=sigmoid([ones(size(X,1),1),X]*Theta1');
    second = sigmoid([ones(size(first,1),1),first]*Theta2');

%   === pre-optimization chunk ===
%  answers = zeros(size(second));
%  
%  index_shift=0;
%  if(min(y)==0)
%      index_shift=1;
%  endif;
%  
%  for(i=1:size(answers,1))
%      answers(i,y(i,1)+index_shift)=1;
%  end;    

%  for(i=1:m)
%      J+=sum((  -1*answers(i,:).*log(second(i,:)) - (1-answers(i,:)).*log(1-second(i,:))),2) ;
%  end;



      index_shift=0;
      %if multiclass classification - shift the labels. otherwise a single 0/1 outpt
      if(min(y)==0 && num_labels>2)
          index_shift=1;
      endif;


    %=== set answers and avoid looping ===%
%      answers = zeros(numel(second),1);
%    
%      step=columns(second);
%      offsets=0:step:numel(second)-step;
%    
%      answers(y.+offsets'+index_shift)=1;
%      answers=reshape(answers, columns(second), rows(second))';

    answers=zeros(size(second));
    for(i=1:columns(second))
        answers(:,i)=(y+index_shift)==i;
    endfor;


    J = sum((-answers .* log(second) - (1-answers) .* log(1-second))(:));
    J=J/m;

    J+=(lambda/(2*m))*(sum(sum(Theta1(:,2:end).^2),2)+sum(sum(Theta2(:,2:end).^2(:)),2));

    errors2=(second.-answers);
    errors1=errors2*Theta2(:,2:end).*(first.*(1-first));
    Theta2_grad+=([ones(size(first,1),1), first]'*errors2)';
    Theta1_grad+=([ones(size(X,1),1), X]'*errors1)';

    Theta2_grad+=[zeros(size(Theta2,1),1),Theta2(:,2:end)].*lambda;
    Theta1_grad+=[zeros(size(Theta1,1),1),Theta1(:,2:end)].*lambda;

    Theta2_grad/=m;
    Theta1_grad/=m;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end;
