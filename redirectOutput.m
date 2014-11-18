function redirectOutput(destinationFile)
%      fprintf('creating fifo %s ... ' ,destinationFile);
%      system(sprintf('mkfifo %s', destinationFile));
    fprintf('opening for appending ...');
    myfile=fopen(destinationFile, 'a');
    fprintf('redirecting output ...');
    [X, Y]=dup2(myfile, stdout);
%   [X, Y]=dup2(myfile, stderr);
endfunction;