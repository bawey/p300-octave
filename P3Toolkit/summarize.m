function summarize(summary, fc, fs, cl)
	for(x=1:length(summary))
		for(y=1:length(summary{x}))
			for(z=1:length(summary{x}{y}))
				printf('feats computation: %15s, feats selection: %20s, classifier (naive): %10s , %s', fc{x}, fs{y}, cl{z}, confusionMatrixInfo(summary{x}{y}{z}.naive));
				printf('feats computation: %15s, feats selection: %20s, classifier (aware): %10s , %s', fc{x}, fs{y}, cl{z}, confusionMatrixInfo(summary{x}{y}{z}.aware));
			endfor;
		endfor;
	endfor;
endfunction;