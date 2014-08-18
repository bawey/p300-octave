function [H, IH] = classifyLogisticRegression(X,Y,eX,eY, MaxIter=400)
	classifier=ClassifierLogReg(X,Y,400);
	
	[p, prob]=classify(classifier, eX);
	
	
	H=zeros(2,2);
	H(1,1)=sum( eY==0 & p==0 );
	H(1,2)=sum( eY==0 & p==1 );
	H(2,1)=sum( eY==1 & p==0 );
	H(2,2)=sum( eY==1 & p==1 );
	
	ip=zeros(size(p));
	[sorted_value, sorted_index] = sort(prob, 'descend');
	ip(sorted_index(1:2))=1;
	
	IH=zeros(2,2);
	IH(1,1)=sum( eY==0 & ip==0 );
	IH(1,2)=sum( eY==0 & ip==1 );
	IH(2,1)=sum( eY==1 & ip==0 );
	IH(2,2)=sum( eY==1 & ip==1 );
	
endfunction;