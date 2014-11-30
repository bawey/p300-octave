%returns a set of (row) vectors conformant with P3Workflow: train samples with positive and test samples with negative indexes
function sv = trainTestSplitMx(samplesCount, splitsCount=samplesCount)
	%create an n x n matrix, identical rows 1:m
	
	samplesCount
	splitsCount
	
	sv=repmat(1:samplesCount, splitsCount, 1);
	%split and shuffle rows
	test_elements_count=samplesCount/splitsCount;
	for(i=1:size(sv,1))
        sv(i, [1:test_elements_count].+(i-1)*test_elements_count).*=-1;
        sv(i,:)=sv(i,:)(randperm(size(sv,2))); 
    endfor;
endfunction;