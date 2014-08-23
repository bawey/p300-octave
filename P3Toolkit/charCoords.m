function [row, col] = charCoords(character)
    row=0; col=0;
    table=charTable();
    for(x=1:length(table))
        if(row~=0)
            break;
        endif;
        for(y=1:length(table))
            if(table{x}{y}==character)
                row=x;
                col=-y;
                break;
            endif;
        endfor;
    endfor;
endfunction;