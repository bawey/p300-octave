function [p, prob] = classify(nn, X)
    
    if(nn.centering == true)
        X = centerTestData(X, nn.tr_mean, nn.tr_std);
    endif;
    
    %PREDICT Predict the label of an input given a trained neural network
    %   p = PREDICT(Theta1, Theta2, X) outputs the predicted label of X given the
    %   trained weights of a neural network (Theta1, Theta2)

    m = size(X, 1);

    h1 = sigmoid([ones(m, 1) X] * nn.Theta1');
    h2 = sigmoid([ones(m, 1) h1] * nn.Theta2');

    prob=h2(:,1);
    p=prob>=0.5;

endfunction;