%   This is a classifier that wraps the octave-nan package
%   sample invocations:
%       ClassifierNan(X, y, 'SVM') %short style

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

    classifier=class(classifier, 'ClassifierNan');

endfunction;