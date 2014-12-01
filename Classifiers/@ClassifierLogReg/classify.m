%ap - aware prediction. assumes that the values passed to classifier corresponded to ...
function [p, prob] = classify(classifier, X)

    if( classifier.centering == true)
        X = centerTestData(X, classifier.tr_mean, classifier.tr_std);
    endif;

    %add one in front, right?
    X= [ones(rows(X),1), X];
    prob = sigmoid(X * classifier.theta);
    p=prob>=0.5;

endfunction;
