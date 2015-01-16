% Function analyzeConfidence(conf) producing some nice plots given the confidence struct like the one used in trainTestMesh
% w
function analyzeConfidence(conf, 
    label_x='Powtorzenia', 
    label_y='Znaki treningowe', 
    label_z='Poziom pewnosci')

    figure;
    
    start_flash = 4;
    
    subplot(2,2,1);
    surf([start_flash:rows(conf.wrong.means)], [1:columns(conf.wrong.means)], conf.right.highs(start_flash:end, :)');
    xlabel(label_x);
    ylabel(label_y);
    zlabel(label_z);
    view(-37.5, 40);
    title('Max. poziom pewnosci - trafne');

    
    subplot(2,2,2);
    surf([start_flash:rows(conf.wrong.means)], [1:columns(conf.wrong.means)], conf.wrong.highs(start_flash:end, :)');
    xlabel(label_x);
    ylabel(label_y);
    zlabel(label_z);
%       view(-217.5, 30)
    view(-37.5, 40);
    title('Max. poziom pewnosci - bledne');
    
    subplot(2,2,3);
    surf([start_flash:rows(conf.wrong.means)], [1:columns(conf.wrong.means)], conf.right.means(start_flash:end, :)');
    xlabel(label_x);
    ylabel(label_y);
    zlabel(label_z);
    view(-37.5, 40);
    title('Sredni poziom pewnosci - trafne');
    
    subplot(2,2,4);
    surf([start_flash:rows(conf.wrong.means)], [1:columns(conf.wrong.means)], conf.wrong.means(start_flash:end, :)');
    xlabel(label_x);
    ylabel(label_y);
    zlabel(label_z);
    view(-37.5, 40);
%      view(-217.5, 30)
    title('Sredni poziom pewnosci - bledne');
    
endfunction;

