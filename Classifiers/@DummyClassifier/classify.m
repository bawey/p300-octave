function [p, prob] = classify(classifier, X)

    prob = ones(rows(X),1);
    p=prob>=0.5;

endfunction;
