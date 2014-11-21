% 
% function [model, tr_mean, tr_std] = trainClassifier(trainSession, modelCell, featsSelectCell, featsComputeCell)
function [model, tr_mean, tr_std, featsMask] = trainClassifier(trainSession, modelCell, featsSelectCell, featsComputeCell)
    % extract the data from P3Session object
    [tfeats, tlabels, tstimuli] = classificationData(trainSession);
    
    % center the data and return back the parameters (mean and std)
    [tfeats, tr_mean, tr_std] = centerTrainData(tfeats);
    
    % compute the features mask AFTER cenetering the data
    featsMask=feval(featsSelectCell{1}, tfeats, tlabels, featsSelectCell{2});
    
    % apply the result features mask to training data
    tfeats = tfeats(:, featsMask);
    
    % train a classifier object
    model = feval(modelCell{1}, tfeats, tlabels, modelCell{2});
    
endfunction;