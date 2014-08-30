%% function features = executeTransformationSteps(features, steps)
%% executes transformation steps defined as objects containing a field 'functionHandle' and 'arguments'
%% the functionHandle should indeed be a function handle taking the features as the first argument and then the contents of 'arguments' field
function feats = executeTransformationSteps(feats, steps)
%      printf('starting with %d feats...', columns(feats));
    for(i=1:length(steps))
        feats=feval(steps{i}.functionHandle, feats, steps{i}.arguments{:});
%          printf('%d...', columns(feats));
    endfor;
%      printf('done.\n');
endfunction;