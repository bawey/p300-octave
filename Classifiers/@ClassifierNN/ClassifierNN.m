function classifier = classifierNN(X, y, hidden_layer_size=32, maxiter=175, lambda=1);

input_layer_size = size(X, 2);
num_labels = length(unique(y));

%binary classification
if(num_labels==2)
    num_labels=1;
endif;

Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
Theta2 = randInitializeWeights(hidden_layer_size, num_labels);

nn_params = [Theta1(:) ; Theta2(:)];
J = nnCostFunction(nn_params, input_layer_size, hidden_layer_size, ...
                   num_labels, X, y, lambda);

%  fprintf(['Cost at parameters (loaded from ex4weights): %f \n'], J);
%  
%  fprintf('Program paused. Press enter to continue.\n');
%  pause;
%  
%  
%  fprintf('\nInitializing Neural Network Parameters ...\n')




%% =================== Part 8: Training NN ===================
%  You have now implemented all the code necessary to train a neural 
%  network. To train your neural network, we will now use "fmincg", which
%  is a function which works similarly to "fminunc". Recall that these
%  advanced optimizers are able to train our cost functions efficiently as
%  long as we provide them with the gradient computations.
%
%  fprintf('\nTraining Neural Network... \n')

%  After you have completed the assignment, change the MaxIter to a larger
%  value to see how more training helps.
options = optimset('MaxIter', maxiter);


% Create "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X, y, lambda);

% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)
[nn_params, cost] = fmincg(costFunction, nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
classifier.Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

classifier.Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

%  fprintf('Program paused. Press enter to continue.\n');
%  pause;


classifier=class(classifier, 'ClassifierNN');

endfunction;