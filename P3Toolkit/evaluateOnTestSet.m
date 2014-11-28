% function evaluates given model using all:1 flashes per stimuli and reports back the performance measured
% function [scores, confdiffs] = evaluateOnTestSet(model, p3s)

function [scores, confidence] = evaluateOnTestSet(model, p3s)
    scores=[];
    confidence = struct();
    confidence.right=struct();
    confidence.wrong=struct();
    confidence.right.highs=[];
    confidence.right.lows=[];
    confidence.right.means=[];
    confidence.wrong.highs=[];
    confidence.wrong.lows=[];
    confidence.wrong.means=[];
    
    for(i = p3s.epochsCountPerStimulus-1: -1 : 0)
        % using i flashes per stimuli. getting all combinations of flashes would be nice, but nchoosek(12,5) is way too much
        p3r = P3SessionReduceRepeats(p3s, i);
        [answers, confs] = askClassifier(model, p3r);
        
        %both column and row have to equal the target. hence the row-wise sum of comparison results shall be 2.
        correct = sum(answers==p3r.targets,2)==2;
        score = sum(correct)/rows(p3r.targets);
        scores=[scores, score];
        
        %check the confidences
        confidence.right.means=[confidence.right.means; mean([confs(correct); NaN])];
        confidence.right.highs=[confidence.right.highs; max([confs(correct); NaN])];
        confidence.right.lows=[confidence.right.lows; min([confs(correct); NaN])];
        
        confidence.wrong.means=[confidence.wrong.means; mean([confs(~correct); NaN])];
        confidence.wrong.highs=[confidence.wrong.highs; max([confs(~correct); NaN])];
        confidence.wrong.lows=[confidence.wrong.lows; min([confs(~correct); NaN])];
            
    endfor;
endfunction;
