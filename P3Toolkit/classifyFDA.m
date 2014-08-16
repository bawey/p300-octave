function [H, IH] = classifyFDA(tfeats, tlabels, vfeats, vlabels)
	vlabels+=1;
	tlabels+=1;
	
	MODE.TYPE='FDA';
	CC=train_sc(tfeats, tlabels, MODE);
	R=test_sc(CC, vfeats, MODE.TYPE, vlabels);
	H=R.H;
	
	[sort_value, sort_index]=sort(R.output(:,2), 'descend');
	ip=zeros(size(vlabels));
	ip(sort_index(1:2))=1;
	IH=zeros(2,2);
	
	IH(1,1)=sum( vlabels==1 & ip==0 );
	IH(1,2)=sum( vlabels==1 & ip==1 );
	IH(2,1)=sum( vlabels==2 & ip==0 );
	IH(2,2)=sum( vlabels==2 & ip==1 );
	
endfunction;