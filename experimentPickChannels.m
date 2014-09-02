%   experimentPickChannels(classifierCell, p3train, title, splitsCount=p3train.periodsCount)
%
%   classifierCell - a cell array containing all the atributes to be passed to the workflow via addFunction
%   sample invocations:
%%       
%       [summary, summary_subsets] = experimentPickChannels({@ClassifierNan, struct('TYPE', 'SVM', 'hyperparameter', struct('c_value',0.01))}, p3train, 'Berlin3a.SVM', 17);
%       [summary, summary_subsets] = experimentPickChannels({@ClassifierNan, struct('TYPE', 'FLDA', 'hyperparameter', struct('gamma',0.001))}, p3train, 'Berlin3b.FLDA', 17);
%
function [summary, summary_subsets] = experimentPickChannels(classifierCell, p3train, title, splitsCount=p3train.periodsCount)

    init();

    %cells for pretty-printing the summary
    fc={}; %Features Computation
    fs={}; %Features Selection
    tt={}; %CLassification

    printf('Splits to generate: %d \n', splitsCount);

    %"OBJECT-ORIENTED"
    w=P3Workflow(p3train, @trainTestSplitMx, {splitsCount});
    w=addFunction(w, 'featsCompute', @featsComputePassThrough);     fc{end+1}='pass-through';

    %BUG! (requires copying the variable before accessing its members)
    channelNames=p3train.channelNames;

    for(ch=1:p3train.channelsCount)
        w=addFunction(w, 'featsSelect', @featsSelectPickChannels, p3train.samplesCountPerEpoch, ch);
        fs{end+1}=sprintf('%d. channel only [%s]', ch, channelNames{ch});
    endfor;
    w=addFunction(w, 'trainTest', classifierCell{:}); tt{end+1}=func2str(classifierCell{1}); %can we convert the classifierCell to a long string? would be good.

    summary=launch(w, fc, fs, tt, sprintf('%s.single.channel.evaluation', title));

    summarize(summary, fc, fs, tt);

    channels_scores=[];
    for(x=1:length(summary))
        for(y=1:length(summary{x}))
            score=0;
            for(z=1:length(summary{x}{y}))
                [nfo, stats] = confusionMatrixInfo(summary{x}{y}{z}.naive);
                subscore=(stats.recall+stats.precision)/2;
                [nfo, stats] = confusionMatrixInfo(summary{x}{y}{z}.aware);
                %subscore is the better of two averages of precision and recal: either for he aware or for the naive classifier
                subscore=max(score, (stats.recall+stats.precision)/2);
                %score for the channel is the best classification subscore for that channel
                score=max(score, subscore);
            endfor;
            channels_scores=[channels_scores; score];
        endfor;
    endfor;

    %remove all the single-channel selecting code and corrresponding printouts
    w=clearFunctions(w, 'featsSelect');
    fs2={};

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
        fs2{end+1}=sprintf('channels %30s [%30s]', mat2str(channels), strcat(channelNames{channels}));
    endfor;

    summary_subsets=launch(w, fc, fs2, tt, sprintf('%s.channels.subset.evaluation', title));

    summarize(summary_subsets, fc, fs2, tt);
endfunction;