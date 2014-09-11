%   A split function producing a single division of the dataset
%   into the training and evaluation part.
function resp = trainTestSplitMerged(samplesCount, nFirstForTraining)
    resp=1:samplesCount;
    resp(resp>nFirstForTraining).*=-1;
endfunction