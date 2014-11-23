%function [bps bpm cpm] = itr(mx_side, highlight_time, dim_time, repeats)
function [bps bpm cpm] = itr(mx_side, highlight_time, dim_time, repeats)

cpm = 60000/(repeats*2*(mx_side)*(highlight_time+dim_time));
bps = cpm*log2(mx_side*mx_side);
bpm = 60*bps;

endfunction;