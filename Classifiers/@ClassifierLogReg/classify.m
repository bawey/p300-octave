function [p, prob] = classify(classifier, X)

%add one in front, right?
X= [ones(rows(X),1), X];
prob = sigmoid(X * classifier.theta);
p=prob>=0.5;	
	
endfunction;