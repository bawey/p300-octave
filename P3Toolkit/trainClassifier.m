%
function [model, tr_mean, tr_std] = trainClassifier(funcHandle, funcParaCell, trainSession)

    funcHandle

    [tfeats, tlabels, tstimuli] = classificationData(trainSession);
    [tfeats, tr_mean, tr_std] = centerTrainData(tfeats);
    
    model = feval(funcHandle, tfeats, tlabels, funcParaCell);
    
endfunction;