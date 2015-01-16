% function results = askClassifier(classifier, p3session, varargin ['verbose'])
%   classifier  - trained classifier object
%   p3session   - data to classify

function [results, confidence] = askClassifier(classifier, p3session, varargin)
    results=[];
    confidence=[];
    
    for(periodNo=1:p3session.periodsCount)
        % labels may well be empty here! this one is for online predictions mainly!
        [feats, labels, stimuli] = classificationData(p3session, [1:p3session.channelsCount], [periodNo]);

        [preds probs] = classify(classifier, feats, stimuli);
        [sign row column labelodds] = periodCharacterPrediction(stimuli, probs);
            
        [confr, confc]=labeloddsConfidence(labelodds);
        cnf = min(confr, confc);
        
        results=[results; row, column];
        confidence=[confidence; cnf];
    endfor;
    
    for(argno=1:length(varargin))
        arg=varargin{argno};
        if(isstr(arg))
            if(strcmp(arg, 'verbose') && sum(p3session.targets)~=0)
                halfTruths = (results == p3session.targets);

                truths = (results == p3session.targets);
                truths = and(truths(:,1), truths(:,2));
                
                halfTruths=reshape(halfTruths, numel(halfTruths), 1);
                fprintf('Correctly regonized %d/%d characters and %d/%d columns or rows.\n', 
                    sum(truths), numel(truths), sum(halfTruths), numel(halfTruths));
            endif;
        endif;
    endfor;
    
endfunction;