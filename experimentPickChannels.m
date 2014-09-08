%   experimentPickChannels(classifierCell, p3train, title, splitsCount=p3train.periodsCount)
%
%   classifierCell - a cell array containing all the atributes to be passed to the workflow via addFunction
%   sample invocations:
%%       
%       [summary, summary_subsets] = experimentPickChannels({@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',0.01))}, p3train, 'Berlin3a.SVM', 17);
%       [summary, summary_subsets] = experimentPickChannels({@ClassifierNan, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',0.001))}, p3train, 'Berlin3b.FLDA', 17);
%
function [p3summary, p3summary_subsets] = experimentPickChannels(classifierCell, p3train, title, splitsCount=p3train.periodsCount)

    init();

    printf('Splits to generate: %d \n', splitsCount);

    %"OBJECT-ORIENTED"
    w=P3Workflow(p3train, {@trainTestSplitMx, splitsCount});
    w=addFunction(w, 'featsCompute', @featsComputePassThrough);

    %BUG! (requires copying the variable before accessing its members)
    channelNames=p3train.channelNames;

    for(ch=1:p3train.channelsCount)
        w=addFunction(w, 'featsSelect', @featsSelectPickChannels, p3train.samplesCountPerEpoch, ch);
    endfor;
    w=addFunction(w, 'trainTest', classifierCell{:}); %can we convert the classifierCell to a long string? would be good.

    p3summary=launch(w, sprintf('%s.single.channel.evaluation', title));

    summary=p3summary.confusionMatrix;
    
    summarize(p3summary);

    channels_scores=[];
    for(x=1:length(summary))
        for(y=1:length(summary{x}))
            score=0;
            for(z=1:length(summary{x}{y}))
                [nfo, stats] = confusionMatrixInfo(summary{x}{y}{z}.naive);
                subscore=stats.f1;
%                  [nfo, stats] = confusionMatrixInfo(summary{x}{y}{z}.aware);
                %subscore is the better of two averages of precision and recal: either for he aware or for the naive classifier
%                  subscore=max(score, (stats.recall+stats.precision)/2);
                %score for the channel is the best classification subscore for that channel
                score=max(score, subscore);
            endfor;
            channels_scores=[channels_scores; score];
        endfor;
    endfor;

    %remove all the single-channel selecting code and corrresponding printouts
    w=clearFunctions(w, 'featsSelect');

    [cs, cn] = sort(channels_scores, 'descend');
    channels_scores=[cs, cn]

    printf('============ Results for single chanel based classifiers  ============\n');
    for(i=1:size(channels_scores,1))
        printf('#%2d. channel %3d [%5s] (score: %.2f) \n', i, channels_scores(i,2), channelNames{channels_scores(i,2)}, channels_scores(i,1));
    endfor;
    printf('============++++++++++++++++++++++++++++++++++++++++++++++============\n');

    for(i=2:size(channels_scores,1))
        %pick the 'best' channels from 1 to i
        channels=channels_scores(1:i,2)';
        w=addFunction(w, 'featsSelect', @featsSelectPickChannels, p3train.samplesCountPerEpoch, channels);
    endfor;

    p3summary_subsets=launch(w, sprintf('%s.channels.subset.evaluation', title));

    summarize(p3summary_subsets);
endfunction;