%function [bps bpm cpm] = itr(mx_side, highlight_time, dim_time, repeats)
function [bps bpm cpm] = itr(mx_side, highlight_time, dim_time, repeats, accuracy)

cpm = 60000/(repeats*2*(mx_side)*(highlight_time+dim_time));

B = log2(mx_side*mx_side) + accuracy * log2(accuracy);

B_add = (1-accuracy)*log2((1-accuracy)/(mx_side*mx_side-1));
if(~isnan(B_add))
    B=B+B_add;
endif;

bps = B / (repeats*(dim_time+highlight_time)*2*mx_side);
bpm = 60*bps;

endfunction;