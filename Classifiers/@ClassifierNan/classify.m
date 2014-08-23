function [p, prob] = classify(classifier, vfeats)
    R=test_sc(classifier.CC, vfeats, classifier.MODE.TYPE);
    prob=(R.output(:,end).+1)./2;
    p=prob>=0.5;
endfunction;