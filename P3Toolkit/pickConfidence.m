% function [scores confidence] = pickConfidence(p3s, modelCell)
% Given the model configuration, retrains the model for all (n-1)-sized subsets of periods and performs
% evaluation on remaining one.
% This is pretty much like cross-validation, except that now we're looking for the confidence levels achieved for
% each left-out period.

% returns the "confidence gaps" matrix, listing the number of repeats used, 
% max observed confidence of correct rulings and max observed confidence of mistakes

function [confidenceGaps scores confidence] = pickConfidence(p3s, modelCell)
    scores = [];
    confidence = struct();
    
    % Go over all periods, marking the current as dead
    for(i=1:p3s.periodsCount)
        % get training data as all periods except the now-dead one
        [feats, labels, stimuli] = classificationData(p3s, [1:p3s.channelsCount], [1:i-1, i+1:p3s.periodsCount]);
        model = modelFromCell(modelCell, feats, labels);

        % dead data makes up the test set
        [vfeats vlabels vstimuli] = classificationData(p3s, [1:p3s.channelsCount], [i]);
        %that stupid issue with copying all
        temptargets = p3s.targets;
        p3t = P3Session(vfeats, vstimuli, temptargets(i,:), p3s.channelsCount, p3s.samplingRate, p3s.channelNames);
        
        [score, confidence_chunk] = evaluateOnTestSet(model, p3t);
        scores=[scores; score];
        
        if(isempty(fieldnames(confidence)))
            confidence = confidence_chunk;
        else
            for(x={'right', 'wrong'})
            x=x{:};
                for(y={'highs', 'lows', 'means'})
                    y=y{:};
                    confidence.(x).(y) = [confidence.(x).(y), confidence_chunk.(x).(y)];
                endfor;
            endfor;
        endif;
    endfor;
    
    confidenceGaps = [];
    
    for(minpers = 1: p3s.epochsCountPerStimulus)
        confidenceGaps=[confidenceGaps; minpers, max(confidence.right.highs(minpers,:)), max(confidence.wrong.highs(minpers,:))];
    endfor;
    
endfunction;