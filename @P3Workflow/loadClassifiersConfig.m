function p3w = loadClassifiersConfig(p3w, fpath, units_only, balanced_only)
    if(exist(fpath)~=2)
        fpath = sprintf('%s.cnf', fpath);
        if(exist(fpath)~=2)
            fprintf('Config file %s not found!\n', fpath);
            return;
        endif;
    endif;
    fid = fopen(fpath);
    while( (line = fgetl(fid))~=-1)
        data = eval(line);
        if(iscell(data))
            if(~units_only)
                  w=addFunction(w, 'trainTest', @BalancedClassifier, data, 'novoting');
            endif;
            if(~balanced_only)
                p3w=addFunction(p3w, 'trainTest', data{1:end});
            endif;            
        endif;
    endwhile;
    fclose(fid);
endfunction;