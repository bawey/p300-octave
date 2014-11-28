%function scores = trainTestMesh(p3tr, p3te, modelCell)
function [scores confidence] = trainTestMesh(p3s, p3t, modelCell)
    scores = [];
    confidence = struct();
    for(i=1:p3s.periodsCount)
        fprintf('Starting with %d training periods \n', i); fflush(stdout);
        % get all possible i-long training subsets? nice, but nchoosek(12,5) or so would yield way too many training configurations
        [feats, labels, stimuli] = classificationData(p3s, [1:p3s.channelsCount], [1:i]);
        model = feval(modelCell{1}, feats, labels, modelCell{[1:end]~=1});
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
endfunction;