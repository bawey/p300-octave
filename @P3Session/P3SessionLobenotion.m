%Constructor for the project's own data format. Its fate is yet to be decided
% P3SessionLobenotion(dirpath, dataname, metaname, targetsname)
%
% OR:
%
% P3SessionLobenotion(dirpath, nameroot) - _meta, _data, _targets are assumed as respecive suffixes
function p3session = P3SessionLobenotion(dirpath, nameroot, metaname, targetsname)
	
	fprintf('path: %s, %s \n', dirpath, nameroot)
	
	% if only one argument is given - the dirpath works as an absolute nameroot
	if(~exist('nameroot', 'var'))
        nameroot=dirpath;
        dirpath="";
    endif;
    
    % check if a binary file has already been saved
    bin_file_name = sprintf('%s/%s.oct', dirpath, nameroot);
    if(exist(bin_file_name,'file')~=0)
        load('-binary', bin_file_name, 'p3session');
    else
        if(~exist('metaname', 'var'))
            metaname=sprintf('%s_meta', nameroot)
            targetsname=sprintf('%s_targets', nameroot);
            dataname=sprintf('%s_data', nameroot);
        else
            dataname = nameroot;
        endif;

        data = load(sprintf('%s/%s', dirpath, dataname));
        meta = load(sprintf('%s/%s', dirpath, metaname));
        targets = load(sprintf('%s/%s', dirpath, targetsname));
        
        p3session=P3SessionLobeRaw(data, meta, targets, 14, 128, {'AF3','AF4','F3','F4','F7','F8','FC5','FC6','T7','T8','P7','P8','O1','O2'});
        save('-binary', bin_file_name, 'p3session');
	endif;
endfunction;