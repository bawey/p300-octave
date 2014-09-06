%   input directory
%   output directory
%   output filename
%   sampleInvocation:
%       convertOpenvibeData('~/Copy/eeg/ov2', '~/Forge/p3data/', 'openvibe.oct')
function convertOpenvibeData(inputdir, outdir, destfilename)
    assert(exist(outdir, 'dir')==7, 'Output directory does not exist');
    p3train=P3SessionOpenVibe(inputdir);
    
    if(exist(outdir)==7)
        savepath=sprintf('%s/%s', outdir, destfilename);
        if(exist(savepath)~=2)
            save('-binary',savepath, 'p3train');
        else
            fprintf('Output file %s exists already!\n', savepath);
        endif;
    else
        fprintf('Output directory %s does not exist!\n', outdir);
    endif;
    
endfunction;