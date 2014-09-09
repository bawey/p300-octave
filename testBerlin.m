%%
%   p3train, p3test - P3Session objects
%   classifier cell, eg. {@ClassifierNN, 128. 150, 6} gets invoked as ClassifierNN(trainfeats, trainlabels, 128, 150, 6)
%
%   sample invocations:
%       testBerlin(p3train, p3test, teststring, {@ClassifierNan, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',0.01))})
%       testBerlin(p3train, p3test, teststring, {@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',1))})
%       testBerlin(p3train, p3test, teststring, {@ClassifierNN, 32, 100, 1})
%       testBerlin(p3train, p3test, teststring, {@ClassifiersBag, 60, @ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',1))})
%       testBerlin(p3train, p3test, teststring, {@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',1))}, {@featsComputePCAWithKSR,1})
%       testBerlin(p3train_g, p3test_g, teststring, {@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',1))}, {@featsComputePassThrough}, {@featsSelectFss, 0.01})
%       testBerlin(p3train_g, p3test_g, teststring, {@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',1))}, {@featsComputePCAWithKSR,1}, {@featsSelectFss, 0.04})
%
%%
function [accuracy predicted] = testBerlin(p3train, p3test, expected, classifierCell, fcCell={@featsComputePassThrough}, fsCell={@featsSelectPassThrough})
    init();

    [feats, labels, stimuli] = classificationData(p3train, [1:p3train.channelsCount], [1:p3train.periodsCount]);
    [feats, tr_mean, tr_std] = centerTrainData(feats);

    spaceTransformationSteps=feval(fcCell{1}, feats, labels, fcCell{[1:end]~=1});
    feats = executeTransformationSteps(feats, spaceTransformationSteps);
    
    feats_mask=feval(fsCell{1}, feats, labels, fsCell{[1:end]~=1});
    feats=feats(:,feats_mask);

    tic;
    classifier = feval(func2str(classifierCell{1}), feats, labels, classifierCell{2:end});
    toc;

    predicted='';
    correct=0;

    for(testperiod=1:p3test.periodsCount)
        [feats, labels, stimuli] = classificationData(p3test, [1:p3test.channelsCount], [testperiod]);
        feats=centerTestData(feats, tr_mean, tr_std);
        feats=executeTransformationSteps(feats, spaceTransformationSteps);
        feats=feats(:,feats_mask);
        [labels, prob]=classify(classifier, feats);
              
        character=periodCharacterPrediction(stimuli, prob);
        predicted=strcat(predicted, character);
        if(character==expected(testperiod))
            ++correct;
        endif;
        
    endfor;
    
    accuracy=correct/length(expected);
endfunction;