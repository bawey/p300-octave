% function evaluates given model using all:1 flashes per stimuli and reports back the performance measured
% function scores = evaluateOnTestSet(model, p3s)
function scores = evaluateOnTestSet(model, p3s)
    scores=[];
    for(i = p3s.epochsCountPerStimulus-1: -1 : 0)
        % using i flashes per stimuli. getting all combinations of flashes would be nice, but nchoosek(12,5) is way too much
        p3r = P3SessionReduceRepeats(p3s, i);
        answers = askClassifier(model, p3r);
        score = sum(sum(answers==p3r.targets,2)==2)/rows(p3r.targets);
        scores=[scores, score];
    endfor;
endfunction;
