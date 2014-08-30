function [p, prob] = classify(bag, X)
    
    fflush(stdout);
    
    prob=zeros(rows(X),1);
    weight_sum=0;
    
    for(c = 1 : length(bag.classifiers))
        weight=bag.std_weight;
        if(c==length(bag.classifiers))
            weight=bag.last_weight;
        endif;
        weight_sum+=weight;
        [cp, cprob]=classify(bag.classifiers{c}, X);
%          prob+=(sextetWiseAwarePrediction(cprob).*weight);
       prob+=(cprob).*weight;
        
    endfor;

%   fprintf('Prob ...\n');
    prob./=weight_sum;
    
    p=prob>=0.5;

endfunction;