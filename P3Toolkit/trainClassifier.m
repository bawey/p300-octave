% function [model, tr_mean, tr_std] = trainClassifier(trainSession, modelCell)
function [model] = trainClassifier(trainSession, modelCell)
    % extract the data from P3Session object
    [tfeats, tlabels, tstimuli] = classificationData(trainSession);
    
    % train a classifier object
    model = feval(modelCell{1}, tfeats, tlabels, modelCell{2});
    
endfunction;