function summary = P3SummaryMerge(p3sa, p3sb)
    functions=[p3sa.functions, p3sb.functions];
    H=[p3sa.confusionMatrix, p3sb.confusionMatrix];
    summary=P3Summary(functions, H);
endfunction;