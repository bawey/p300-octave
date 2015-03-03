% quick and dirty.
% use sth like this: print('~/Desktop/aa.png','-dpng','-r600','-S800,1300', '-F:2');

function analyzeConfidences(mode, varargin)
    
    label_x='Powtorzenia'; 
    label_y='Znaki treningowe'; 
    label_z='';

    
    start_flash = 3;
    plotcount=1;
    
    rcnt = numel(varargin)/2;
    figure;
    for(conf = varargin)
        %subplot(rcnt, 2, plotcount:(plotcount+1));
        %title('Ojej');
        %plotcount+=2;
        hold on;    
        conf=conf{:};
        start_flash:rows(conf.wrong.means)
        subplot(rcnt,2,plotcount++);
        %view(-37.5, 40);
        
        maxx=rows(conf.wrong.means);
        maxy=columns(conf.wrong.means);
        
        values = [];
        if(strcmp(mode, 'diff'))
            values = conf.right.highs(start_flash:end, :)'-conf.wrong.highs(start_flash:end, :)';
        elseif(strcmp(mode, 'right'))
            values = conf.right.highs(start_flash:end, :)';
        else
            values = conf.wrong.highs(start_flash:end, :)';
        endif;
        
        surf([start_flash:maxx], [1:maxy], values);
        xlabel(label_x);
        ylabel(label_y);
        zlabel(label_z);
        title(sprintf('Dane %c', 63+plotcount));
        axis tight;
%          zlim([-0.1,0.2]);
        hold off;
    endfor;
    print(sprintf('~/Desktop/confanal_%s.png', mode),'-dpng','-r300','-S800,500');
endfunction;