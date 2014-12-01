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
    
    %sufficiently large margins could be sigmoided
%      fprintf('Classifier type is %s and spread is %.3f \n', classifier.MODE.TYPE, classifier.spread);
    
    %was 10, but we want sigmoid - IT's not this
%      if(classifier.spread<=10)
%      	prob=(distance-classifier.offset)/classifier.spread;
%      else
    distance.-=classifier.threshold;
    prob=sigmoid(distance);
    
%      endif;

    p=(prob>=0.5);
endfunction;