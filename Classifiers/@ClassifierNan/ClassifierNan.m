%   This is a classifier that wraps the octave-nan package
%   sample invocations:
%       ClassifierNan(X, y, 'SVM') %short style
%       ClassifierNan(X, y, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',1))); %long style

function classifier = ClassifierNan(X, y, mode)
    
    MODE=struct();
    if(ischar(mode))
        MODE.TYPE='mode';
    else
        MODE=mode;
    endif;

    y=sign(y-0.5);

    CC=train_sc(X, y, MODE);
    
    classifier.MODE=MODE;
    classifier.CC=CC;

    %rename marguin to cutoof
    classifier.threshold=0;

    classifier=class(classifier, 'ClassifierNan');

    %margin=abs(min(positives))-abs(max(negatives));

    [p, prob] = classify(classifier, X);
    
    truth=[y, prob];

    max_n=max(truth(truth(:,1)~=1,2));
    min_p=min(truth(truth(:,1)==1,2));

    classifier.threshold=0.5*(min_p+max_n)

    classifier=class(classifier, 'ClassifierNan');

endfunction;