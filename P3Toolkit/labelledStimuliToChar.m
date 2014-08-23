function character = labelledStimuliToChar(stimuli, labels)
		coords=stimuli(labels==1);
		character=characterAt(coords(coords>0), -coords(coords<0));
endfunction;