function plotScoresMesh( 
    scores, 
    label_x='Liczba powtorzen (test)', 
    label_y='Liczba znakow (trening)', 
    label_z='Trafnosc klasyfikacji'
)

    figure;

    meshc(1:columns(scores), 1:rows(scores), scores);
    xlabel(label_x);
    ylabel(label_y);
    zlabel(label_z);

    
endfunction;