function mask = featsSelectFss(feats, labels, thold=0.1)
    xycorr=[]; for(c=1:columns(feats)) xycorr=[xycorr, abs(corr([feats(:,c), labels])(2,1))]; endfor;
    [vals, idx2]=sort(xycorr,'descend');
    mask=find(xycorr>thold);
    if(length(mask)==0)
        [x, ix]=max(xycorr);
        mask=ix;
        printf('ffeatsSelectFss removed all the features. Had to insert the mostly correlated into the mask!');
    endif;
      printf('picking %d features\n', length(mask)); fflush(stdout);
endfunction;