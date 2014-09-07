% Feature selection method taking other feature selection methods as parameters.
% Result mask is an intersection of all submasks.
% sample invocations:
%       featsSelectCombineMethods(feats, labels, {@featsSelectPassThrough}, {@featsSelectFss, 0.01});
%
%       feval(@featsSelectCombineMethods, rand(1,140), [], {@featsSelectPassThrough}, {@featsSelectPickChannels, 10, 7})
function mask = featsSelectCombineMethods(feats, labels, varargin)
    
    mask=ones(1, columns(feats));
    
    for(i=1:length(varargin))
        step=varargin{i};
        submask=feval(step{1}, feats, labels, step{[1:end]~=1});
        if(size(submask)~=size(mask))
            submask_=zeros(size(mask));
            submask_(submask)=1;
            submask=submask_;
        endif;
        mask=mask & submask;
    endfor;

    mask=find(mask==1);
    
endfunction;