%       sample invocations:
%               wf = P3WorkflowClassifierGridSearch(p3train, {@trainTestSplitMx});
%
% function w = P3WorkflowClassifierGridSearch(p3train, splitCell, classifiers='dummy\all\slow\fast\fastest', balancing='yes\no\only')

function w = P3WorkflowClassifierGridSearch(p3train, splitCell, classifiers='all', balancing='no') 
    
    w=P3Workflow(p3train, splitCell);

    w=addFunction(w, 'featsCompute',    @featsComputePassThrough);
    w=addFunction(w, 'featsSelect',     @featsSelectPassThrough);
    
    % %%%%%%%%%%%%% PARSE PARAMATERS %%%%%%%%%%%% %
    units_only = strcmp(balancing, 'no');
    balanced_only = strcmp(balancing, 'only');
    
    w=loadClassifiersConfig(w, classifiers, units_only, balanced_only);

endfunction;