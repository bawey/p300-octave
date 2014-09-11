function [p, prob, distance] = classify(classifier, vfeats)
    R=test_sc(classifier.CC, vfeats, classifier.MODE.TYPE);

    R.output;

    distance=R.output(:,end).-classifier.threshold;
    prob=sigmoid(distance);
    
    %if(columns(R.output)>1)
    %    (prob.-=R.output(:,1))./2;
    %endif;

    p=prob>=0.5;
endfunction;