%clears functions list associated with stage indicated
function w = addFunction(w, stage)
	nameFound=false;
	for(name=fieldnames(w.functions)')
		if(strcmp(stage, name{1})==1)
			nameFound=true;
		endif;
	endfor;
	if(~nameFound)
		error('Stage name %s not found!\n',stage);
	endif;
	w.functions.(stage)={};
endfunction;