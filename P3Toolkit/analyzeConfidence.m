% Function analyzeConfidence(conf) producing some nice plots given the confidence struct like the one used in trainTestMesh
% w
function analyzeConfidence(conf, 
    label_x='Powtorzenia', 
    label_y='Znaki treningowe', 
    label_z='Poziom ufnosci')

    figure;
    
    subplot(2,2,1);
    surf([1:rows(conf.wrong.means)], [1:columns(conf.wrong.means)], conf.right.highs');
    xlabel(label_x);
    ylabel(label_y);
    zlabel(label_z);
    title('Max. poziom ufnosci - trafne');

    
    subplot(2,2,2);
    surf([1:rows(conf.wrong.means)], [1:columns(conf.wrong.means)], conf.wrong.highs');
    xlabel(label_x);
    ylabel(label_y);
    zlabel(label_z);
    view(-37.5, 30)
    title('Max. poziom ufnosci - bledne');
    
    subplot(2,2,3);
    surf([1:rows(conf.wrong.means)], [1:columns(conf.wrong.means)], conf.right.means');
    xlabel(label_x);
    ylabel(label_y);
    zlabel(label_z);
    title('Sredni poziom ufnosci - trafne');
    
    subplot(2,2,4);
    surf([1:rows(conf.wrong.means)], [1:columns(conf.wrong.means)], conf.wrong.means');
    xlabel(label_x);
    ylabel(label_y);
    zlabel(label_z);
    view(-37.5, 30)
    title('Sredni poziom ufnosci - bledne');
    
endfunction;

