% function [confr, confc] = labeloddsConfidence(labelodds)
%   @param labelodds - a matrix stimuli_number x 2: label, probability
%
function [confr, confc] = labeloddsConfidence(labelodds)
    colodds = labelodds(labelodds(:,1)<0, 2);
    rowodds = labelodds(labelodds(:,1)>0, 2);
    
    colodds=sort(colodds);
    rowodds=sort(rowodds);
    
    confr = rowodds(end)/(rowodds(end)+rowodds(end-1));
    confc = colodds(end)/(colodds(end)+colodds(end-1));
    
%      confr=sqrt(max(rowodds)^2/sum(rowodds.^2));
%      confc=sqrt(max(colodds)^2/sum(colodds.^2));
    
endfunction;