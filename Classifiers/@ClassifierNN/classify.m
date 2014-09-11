function [p, prob] = classify(nn, X)
%PREDICT Predict the label of an input given a trained neural network
%   p = PREDICT(Theta1, Theta2, X) outputs the predicted label of X given the
%   trained weights of a neural network (Theta1, Theta2)

m = size(X, 1);

h1 = sigmoid([ones(m, 1) X] * nn.Theta1');
h2 = sigmoid([ones(m, 1) h1] * nn.Theta2');

[dummy, p] = max(h2, [], 2);

p.-=1;
prob=h2(:,1);

endfunction;