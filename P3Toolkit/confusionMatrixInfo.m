function [nfo, stats] = confusionMatrixInfo(H)
	stats=struct();
	stats.tn=H(1,1);
	stats.tp=H(2,2);
	stats.fp=H(1,2);	
	stats.fn=H(2,1);
	stats.precision=stats.tp/(stats.tp+stats.fp);
	stats.recall=stats.tp/(stats.tp+stats.fn);
	stats.specificity=stats.tn/(stats.tn+stats.fp);
	stats.sensitivity=stats.tp/(stats.tp+stats.fn);
	stats.accuracy=(stats.tp+stats.tn)/(stats.tp+stats.tn+stats.fp+stats.fn);

	nfo = sprintf('accuracy %.2f : precision %.2f : recall %.2f : specificity %.2f : sensitivity %.2f\n',  stats.accuracy, stats.precision, stats.recall, stats.specificity, stats.sensitivity);

endfunction;