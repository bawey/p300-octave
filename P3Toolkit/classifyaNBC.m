function H=classifyaNBC(tfeats, tlabels, vfeats, vlabels)
	vlabels+=1;
	tlabels+=1;
	%printf('The labels I can see: max - %d, min - %d \n', max(tlabels), min(tlabels));
	MODE.TYPE='aNBC';
	CC=train_sc(tfeats, tlabels, MODE);
	R=test_sc(CC, vfeats, MODE.TYPE, vlabels);
	H=R.H;
endfunction;