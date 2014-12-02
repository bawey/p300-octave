function mx = adjustConfusionMx(mx)
    totals = sum(mx, 2);
    factor = max(totals)/min(totals);
    mx(totals==min(totals), :).*=factor;
endfunction;