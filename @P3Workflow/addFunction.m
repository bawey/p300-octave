%Feature Space manipulation function needs to take [training features, training labels, validation features]
%as arguments before accepting the varargin provided here

%Feature Selection function needs to take [training features, training labels] as parameters
%before taking varargin

%Training and Test function needs to take [training features, training labels, validation features, validation labels]
%as its first four parameters

%stages are: featsComputre, featsSelect, classify
function w = addFunction(w, stage, fHandle, varargin)
	nameFound=false;
	for(name=fieldnames(w.functions)')
%  		printf('Checking against stage name %s \n', name{1})
		if(strcmp(stage, name{1})==1)
			nameFound=true;
		endif;
	endfor;
	if(~nameFound)
		error('Stage name %s not found!\n',stage);
	endif;
%  	printf('shall add a function to %s \n', stage)
	f=struct();
	f.functionHandle=fHandle;
	f.arguments=varargin;
	w.functions.(stage){end+1}=f;
endfunction;