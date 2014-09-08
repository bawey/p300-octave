function [p, prob] = classify(classifier, vfeats)
    R=test_sc(classifier.CC, vfeats, classifier.MODE.TYPE);

    R.output;

    printf('classifier margin: %f\n', classifier.margin);

    prob=R.output(:,end)-classifier.margin;
    
    %if(columns(R.output)>1)
    %    (prob.-=R.output(:,1))./2;
    %endif;

    p=prob>0;
endfunction;