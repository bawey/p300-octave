% This method simulates classifying non-full periods using only [1..epochsCountPerStimulus] rounds
% As arguments it takes: the model, the data, minimum confidence value and minimum flashes used before the confidence is considered
% askAndConfide(model, p3s, minCnf, minFlashes)
function [results confidence flashesUsed accuracy] = askAndConfide(model, p3s, minCnf, minFlashes)
    
    flashesUsed = [];
    results = [];
    confidence=[];
    
    for(periodNo = 1:p3s.periodsCount)
        % DATA to be classified
        [allfeats, alllabels, allstimuli] = classificationData(p3s, [1:p3s.channelsCount], [periodNo]);
        
        % store the number of flashes and number of distinct stimuli
        flashBunchSize = p3s.epochsCountPerStimulus;
        stimTypes = numel(unique(allstimuli));
        
        for(flashes = minFlashes : flashBunchSize)
            
            % take only the data corresponding to analized flashes
            feats       = allfeats(1:flashes*stimTypes, :);
            stimuli     = allstimuli(1:flashes*stimTypes, :);
            labels      = alllabels(1:flashes*stimTypes, :);
        
            [preds probs] = classify(model, feats, stimuli);
            [sign row column labelodds] = periodCharacterPrediction(stimuli, probs);
            [confr, confc]=labeloddsConfidence(labelodds);
            cnf = min(confr, confc);
            if(cnf >= minCnf || flashes == flashBunchSize)
                % fprintf('Confidence %.3f or %d flashes reached \n', cnf, flashes);
                results=[results; row, column];
                confidence=[confidence; cnf];
                flashesUsed=[flashesUsed; flashes];
                break;
            endif;
        
        endfor;
        
    endfor;

    halfTruths = (results == p3s.targets);

    truths = (results == p3s.targets);
    truths = and(truths(:,1), truths(:,2));
                
    halfTruths=reshape(halfTruths, numel(halfTruths), 1);
                
    fprintf('Correctly reconized %d/%d characters and %d/%d columns or rows.\n', 
        sum(truths), numel(truths), sum(halfTruths), numel(halfTruths));
    
    accuracy = sum(truths) / numel(truths);
    
endfunction;