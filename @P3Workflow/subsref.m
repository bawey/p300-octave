%this method will provide access to object's fields
function b = subsref (a, s)
	if (isempty (s))
		error ('P3Workflow: missing index');
	endif
	
	fld = s.subs;
	b=a.(fld);
    
endfunction