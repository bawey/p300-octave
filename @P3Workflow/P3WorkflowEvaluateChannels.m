%takes indicated methods and performs a channel-by-channel train-evaluate cycle on the data.
%sample invocation:
%       P3WorkflowEvaluateChannels(p3train, {@featsComputePassThrough}, {@featsSelectPassThrough},      ...
%               {@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',0.01))},         ...
%               {@trainTestSplitMx, 5})
function p3w = P3WorkflowEvaluateChannels(p3train, fcCell, fsCell, ttCell, dataSplitCell)
    p3w=P3Workflow(p3train, dataSplitCell);
    p3w=addFunction(p3w , 'featsCompute' , fcCell{:});
    p3w=addFunction(p3w , 'trainTest'    , ttCell{:});
    
    for(ch=1:p3train.channelsCount)
        featsSelectCell={@featsSelectCombineMethods, {@featsSelectPickChannels, p3train.samplesCountPerEpoch, ch}, fsCell};
        p3w=addFunction(p3w , 'featsSelect'  , featsSelectCell{:});
%          THAT'S A WAY TO VERIFY THAT COMBINING SELECTION METHODS DOES THE JOB WELL
%          p3w=addFunction(p3w , 'featsSelect'  , @featsSelectPickChannels, p3train.samplesCountPerEpoch, ch);
    endfor;
endfunction;