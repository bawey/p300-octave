%function p3s = P3SessionLobeShorthand(datadir, subject, sessions)

function p3s = P3SessionLobeShorthand(datadir, subject, sessions)
    
    printf('arg 1 (datadir) typeinfo %s \n', typeinfo(datadir));
    datadir
    printf('arg 2 (subject) typeinfo %s \n', typeinfo(subject));
    subject
    printf('arg 3 (sessions) typeinfo %s \n', typeinfo(sessions));
    sessions
    
    p3s=NaN;
    
    for(sessionNo = sessions)
        dataFile    = sprintf('%s_session_%03d_data', subject, sessionNo)
        metaFile    = sprintf('%s_session_%03d_meta', subject, sessionNo)
        targetsFile = sprintf('%s_session_%03d_targets', subject, sessionNo)
        
        if(isobject(p3s))
            p3s=P3SessionMerge(p3s, P3SessionLobenotion(datadir, dataFile, metaFile, targetsFile));
        else
            p3s=P3SessionLobenotion(datadir, dataFile, metaFile, targetsFile);
        endif;
    endfor;
endfunction;