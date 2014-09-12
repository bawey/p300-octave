function [p, prob, distance] = classify(classifier, vfeats)
    R=test_sc(classifier.CC, vfeats, classifier.MODE.TYPE);

    printf('R.output has %d columns! \n', columns(R.output));

    %turns out this corresponds to how our classes are converted in the end:
    distance=-R.output(:,1).-classifier.threshold;
    %prob=sigmoid(distance); %prob=distance;
    prob=(distance-classifier.offset)/classifier.spread;
    % prob=min(1, max(prob, 0));
    
    %if(columns(R.output)>1)
    %    (prob.-=R.output(:,1))./2;
    %endif;

    p=prob>=0.5;
endfunction;