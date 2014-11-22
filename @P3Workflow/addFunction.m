%Feature Space manipulation function needs to take [training features, training labels, validation features]
%as arguments before accepting the varargin provided here

%Feature Selection function needs to take [training features, training labels] as parameters
%before taking varargin

%Training and Test function needs to take [training features, training labels, validation features, validation labels]
%as its first four parameters

%stages are:            featsCompute, featsSelect, trainTest
%artificial stages are: bagging
function w = addFunction(w, stage, fHandle, varargin)
	nameFound=false;
	for(name=fieldnames(w.functions)')
%  		printf('Checking against stage name %s \n', name{1})
		if(strcmp(stage, name{1})==1)
			nameFound=true;
		endif;
	endfor;

    f=struct();
    f.functionHandle=fHandle;
    f.arguments=varargin;
	
	%bagging will be a special type of trainTest stage where trainset will be the testset! - BUT WHY?!
	if(strcmp('bagging',stage)==1)
        nameFound=true;
        f.bagging=true;
        stage='trainTest';
	endif;
	
	if(~nameFound)
		error('Stage name %s not found!\n',stage);
	endif;
	
    %   printf('shall add a function to %s \n', stage)
    w.functions.(stage){end+1}=f;

endfunction;