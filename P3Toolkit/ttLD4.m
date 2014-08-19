function H= ttLD4(tfeats, tlabels, vfeats, vlabels)
%  	tlabels.*=2;
%  	tlabels.-=1;
%  	
%  	vlabels.*=2;
%  	vlabels.-=1;


	vlabels+=1;
	tlabels+=1;
	
%  	printf('The labels I can see: max - %d, min - %d \n', max(tlabels), min(tlabels));
	MODE.TYPE='LD4';
	CC=train_sc(tfeats, tlabels, MODE);
	R=test_sc(CC, vfeats, MODE.TYPE, vlabels);
	H=R.H;
	
endfunction;