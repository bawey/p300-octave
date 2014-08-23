%makes sense only if prob(abilities) correspond to a series of one or more stimuli sextets (-6:-1) or (1:6)
function ap = sextetWiseAwarePrediction(prob)
    ap=zeros(size(prob));

    %going down through every sextet...
    for(i=1:6:rows(prob)-5)
        %... find the best among the six...
        [val, ind]=max(prob(i:i+5)); 
        %... mark it as the answer as the six are mutually exclusive
        ap(ind+i-1)=1;
    endfor;

endfunction;