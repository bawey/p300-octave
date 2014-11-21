function mask = featsSelectFss(feats, labels, featslimit=100)
    cpu_starttime=cputime;
    xycorr=[]; 
      
    c=abs(corr(feats, double(labels)));
    c(isnan(c))=0;
    [val pos]=sort(c, 'descend');
    featslimit=min(featslimit, columns(feats));
    mask = pos(1:featslimit);
    
%      for(c=1:columns(feats)) 
%          xycorr=[xycorr, abs(corr([feats(:,c), labels])(2,1))]; 
%      endfor;
%      
%      [vals, idx2]=sort(xycorr,'descend');
%      mask=find(xycorr>thold);
%      if(length(mask)==0)
%          [x, ix]=max(xycorr);
%          mask=ix;
%          printf('ffeatsSelectFss removed all the features. Had to insert the mostly correlated into the mask!');
%      endif;
    
    cputotal = cputime - cpu_starttime;
      printf('FSS: picking %d features, ranging in correlation value from %.3f to %.3f. Selection took %.3f seconds\n', length(mask), val(1), val(featslimit), cputotal); fflush(stdout);
endfunction;