function str = stringify(sth)
    if(is_function_handle(sth))
        str=func2str(sth);
    elseif(isa(sth, 'struct'))
        fnames=fieldnames(sth);
        strings=[];
        for(fieldno = 1:length(fnames))
            strings=[strings, sprintf('%s: %s', fnames{fieldno}, stringify(sth.(fnames{fieldno})))];
            
            if(fieldno<length(fnames))
                strings=[strings, ', '];
            endif;
            
        endfor;
        
        str=strcat('{',strvcat(cellstr(strings)),'}');
       
    elseif(isa(sth, 'cell'))
        
        strings=[];
        for(i=1:length(sth))
            strings=[strings, stringify(sth{i})];
            if(i<length(sth))
                strings=[strings, ', '];
            endif;
        endfor;
        
        str=strcat('[',strvcat(cellstr(strings)),']');
        
    elseif(isa(sth, 'integer') || (isa(sth, 'numeric') && sth==floor(sth)))
        str = sprintf('%d', sth);   
    elseif(isa(sth, 'float'))
        str = sprintf('%.3f', sth);
    else
        str=sth;
    endif;
endfunction;