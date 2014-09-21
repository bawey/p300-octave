function summary = P3SummaryMerge(p3sa, p3sb)
    functions=struct();
%      for(fieldname_wrapped=fieldnames(p3sa.functions)')
%          fieldname=fieldname_wrapped{:};
%          functions.(fieldname)=[p3sa.functions.(fieldname), p3sb.functions.(fieldname)]
%      endfor;

    functions.featsCompute=p3sa.functions.featsCompute;
    functions.featsSelect=p3sa.functions.featsSelect;
    functions.trainTest=[p3sa.functions.trainTest, p3sb.functions.trainTest];

    H=p3sa.confusionMatrix;
    H{1}{1}=[p3sa.confusionMatrix{1}{1}, p3sb.confusionMatrix{1}{1}];
    summary=P3Summary(functions, H);
endfunction;