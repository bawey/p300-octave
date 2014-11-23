%%This is a demo file for the experiments carried out on the dumps obtained with Emotiv Epoc

% defining the locations and subjects
eeg_dir = '~/Desktop/eeg';
subjects={struct('name', 'valya', 'sessions', [0 1 2 3]),struct('name', 'tomek', 'sessions', [9 11 12 14 15 16 17])};

for(i=1:length(subjects))
    fprintf('%d subject',i);
    %shuffle subject's sessions
    subjects{i}.sessions = subjects{i}.sessions(randperm(length(subjects{i}.sessions)));
    
    %generate the path that the binary file would be saved to / loaded from
    bin_filename = sprintf('%s/%s_sessions.oct', eeg_dir, subjects{i}.name);
    
    if(exist(bin_filename, 'file')~=0 && 
            yes_or_no(sprintf('Subject %s sessions already present on the drive. Load em all? \n', subjects{i}.name)) )
        load('-binary', bin_filename);
    else
        p3tr=NaN;
        p3te=NaN;
    
        for(j=1:length(subjects{i}.sessions))
            session_filename_root = sprintf('%s_session_%03d', subjects{i}.name, subjects{i}.sessions(j));
            if(j==1)
                p3tr=P3SessionLobenotion(eeg_dir,session_filename_root);        
            elseif(j==2)
                p3te=P3SessionLobenotion(eeg_dir,session_filename_root);        
            elseif(mod(j,2)==1)
                p3tr=P3SessionMerge(p3tr, P3SessionLobenotion(eeg_dir,session_filename_root));        
            else
                p3te=P3SessionMerge(p3te, P3SessionLobenotion(eeg_dir,session_filename_root));        
            endif;
        endfor;
            
        p3tr=downsample(p3tr, 6);
        p3te=downsample(p3te, 6);
            
        %save the result file for later
        save('-binary', p3tr, p3te, bin_filename);
    endif;
      
endfor;