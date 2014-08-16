%returns a set of (row) vectors conformant with P3Workflow: train samples with positive and test samples with negative indexes
function sv = trainTestSplitMx(samplesCount)
	%create an n x n matrix, identical rows 1:m
	sv=repmat(1:samplesCount, samplesCount, 1);
	%make elements on the diagonal negative
	sv=sv-sv.*eye(samplesCount)*2;
	%shuffle rows
	for(i=1:size(sv,1)) sv(i,:)=sv(i,:)(randperm(size(sv,2))); endfor;
endfunction;