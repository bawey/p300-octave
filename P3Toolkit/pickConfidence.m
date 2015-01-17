% takes confidence gaps as returned by getConfGaps
% and returns suggested confidence level and minimal required flashes
function [cnf minReps] = pickConfidence(gaps, risk = 0.5)
      
    minReps = rows(gaps);
    cnf=1;
    
    % mean(mean(gaps(2:end,2:end)))
    
    figure;
    plot(gaps(:,1),gaps(:,3), 'ro');
    hold on
    plot(gaps(:,1), gaps(:,2), 'go');
    hold on
%   plot(gaps(:,1), gaps(:,2)-gaps(:,3), 'x');
    
%      xpnt = max(find(gaps(:,2)<gaps(:,3)));
%      
%      max_margin = max(max(gaps(:,2)-gaps(:,3)))
%      
%      if(xpnt<11)
%          cnf = mean(gaps(xpnt+2, 2:3));
%          minReps = xpnt+2;
%      endif;
    
    % 
    surfs = [];
    centers = [];
    
    for(reps = gaps(end,1) : -1 : gaps(1,1))
        lowerBound = max ( gaps(reps:end, 3) );
        upperBound = min( gaps(reps:end, 2) );
        if(upperBound>lowerBound)
            center = (upperBound*(1-risk) + risk*lowerBound);
        else
            center = NaN;
        endif;
        
        centers = [center; centers];
        surf = (upperBound - lowerBound) * (gaps(end,1)-reps);        
        surfs = [surf; surfs];
    endfor;
    
    [maxsurf, maxind] = max(surfs);
    
    cnf = centers(maxind);
    minReps = maxind;
    
    plot(gaps(:,1), surfs, 'b:');
    plot(gaps(:,1), centers, 'b*');
    
    
    legend('Maksymalna pewnosc blednych wskazan', 'Maksymalna pewnosc trafnych wskazan', 
           'Pow. prostokata wpisanego pomiedzy trafne i błedne', 'Sugerowany prog pewnosci', 'location', 'southeast');
    
    axis([0,rows(gaps)+1,0.8*min(gaps(:,2:end)(:)),1.11*max(gaps(:,2:end)(:))]);
    xlabel('Liczba powtorzen podczas klasyfikacji');
    hold off;

endfunction;