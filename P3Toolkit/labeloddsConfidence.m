function [confr, confc] = labeloddsConfidence(labelodds)
    colodds = labelodds(labelodds(:,1)<0, 2);
    rowodds = labelodds(labelodds(:,1)>0, 2);
    
    confr=sqrt(max(rowodds)^2/sum(rowodds.^2));
    confc=sqrt(max(colodds)^2/sum(colodds.^2));
    
endfunction;