%   This is a classifier that wraps the octave-nan package
%   sample invocations:
%       ClassifierNan(X, y, 'SVM') %short style
%       ClassifierNan(X, y, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',1))); %long style

function classifier = ClassifierNan(X, y, mode)

    classifier = struct();
    
    % May the classifier object store data parameters
    [X, tr_mean, tr_std] = centerTrainData(X);
    classifier.tr_mean = tr_mean;
    classifier.tr_std = tr_std;
    

    %   CRAZY!
    % !!it seems that SVM is sensitive towards what label it sees first.
    %   Hence for SVM to work properly the first label needs to be a 0! 
    %
    %   find the first such label:
    head=find(y==0)(1);
    y=[y(head,:); y([1:end]~=head,:)];
    X=[X(head,:); X([1:end]~=head,:)];
    
    MODE=struct();
    if(ischar(mode))
        MODE.TYPE=mode;
    else
        MODE=mode;
    endif;

    y=sign(y-0.5);

    CC=train_sc(X, y, MODE);
    
    classifier.MODE=MODE;
    classifier.CC=CC;

    classifier.threshold=0;
    classifier.offset=0;
    classifier.spread=0;

    classifier=class(classifier, 'ClassifierNan');

    [p, prob, distance] = classify(classifier, X);
    
    truth=[y, distance];

    max_n=max(truth( ( truth(:,1)~=1 )  ,2));
    min_p=min(truth( ( truth(:,1)==1 )  ,2));
    
%      alt_threshold=mean(truth( ( (truth(:,1)~=1 & truth(:,2)>min_p ) | ( truth(:,1)==1 & truth(:,2)<max_n ) ), 2));
%      classifier.threshold=alt_threshold;

    classifier.threshold=0.5*(min_p+max_n);
    
%   fprintf('Classfier threshold at %.3f\n', classifier.threshold);

    %TRYING SOMETHING NEW OUT
    classifier.offset=min(distance);
    classifier.spread=max(distance)-classifier.offset;

    classifier=class(classifier, 'ClassifierNan');

endfunction;