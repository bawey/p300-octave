function nfo = confusionMatrixInfo(H)
	tn=H(1,1);
	tp=H(2,2);
	fp=H(1,2);	
	fn=H(2,1);
	precision=tp/(tp+fp);
	recall=tp/(tp+fn);
	specificity=tn/(tn+fp);
	sensitivity=tp/(tp+fn);
	accuracy=(tp+tn)/(tp+tn+fp+fn);

	nfo = sprintf('accuracy %.2f : precision %.2f : recall %.2f : specificity %.2f : sensitivity %.2f\n',  accuracy, precision, recall, specificity, sensitivity);

endfunction;