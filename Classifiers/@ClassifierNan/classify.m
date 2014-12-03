function [p, prob, distance] = classify(classifier, vfeats)
    
    if(classifier.centering == true)
        vfeats = centerTestData(vfeats, classifier.tr_mean, classifier.tr_std);
    endif;

    R=test_sc(classifier.CC, vfeats, classifier.MODE.TYPE);

    % printf('R.output has %d columns! \n', columns(R.output));

    %turns out this corresponds to how our classes are converted in the end:
    %ORIGINAL: distance=-R.output(:,1); TEST (SVM issues:)
    distance=[];
    if(columns(R.output)>1)
        distance =-R.output(:,1);
    else
        distance = R.output(:,1);
    endif;
    
    
    prob=[];
    prob=sigmoid(distance-classifier.threshold);
    p=prob>0.5;
    
%      prob=[];
%      if(ismember(classifier.MODE.TYPE, {'FLDA'}))
%          prob=sigmoid(5*distance);
%      elseif(ismember(classifier.MODE.TYPE, {'SVM'}))
%          prob=sigmoid(distance-classifier.threshold);
%      endif;
%      p=(prob>=0.5);
endfunction;