% Feature selection method taking other feature selection methods as parameters.
% Result mask is an intersection of all submasks.
% sample invocations:
%       featsSelectCombineMethods(feats, labels, {@featsSelectPassThrough}, {@featsSelectFss, 0.01});
function mask = featsSelectCombineMethods(feats, labels, varargin)
    
    mask=ones(1, columns(feats));
    
    for(i=1:length(varargin))
        step=varargin{i};
        submask=feval(step{i}, feats, labels, step{[i:end]~=1});
        mask=mask & submask;
    endfor;

endfunction;