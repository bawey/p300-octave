%   function p = estimateBagPerformance(units, rate)
%           units:  number of unit classifiers
%           rate:   avg classification rate of a unit
function p = estimateBagPerformance(units, rate)
    majority=ceil(units/2);
    
    prob_mistake=0;
    
    for(wrong = majority:units)
        prob_mistake+=nchoosek(units, wrong) * (1-rate)^wrong * rate^(units-wrong);
    endfor;
    
    p=1-prob_mistake;
endfunction;