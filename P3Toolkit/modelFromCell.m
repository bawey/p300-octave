function model = modelFromCell(modelCell, feats, labels)
    model = feval(func2str(modelCell{1}), feats, labels, modelCell{[1:end]~=1});
endfunction;