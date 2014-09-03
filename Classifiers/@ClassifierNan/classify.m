function [p, prob] = classify(classifier, vfeats)
    R=test_sc(classifier.CC, vfeats, classifier.MODE.TYPE);

    prob=R.output(:,end);
    
    if(columns(R.output)>1)
        (prob.-=R.output(:,1))./2;
    endif;

    p=prob>=0.5;
endfunction;