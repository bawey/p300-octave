init();
%assume p3test and p3train are defined

%some structures for pretty printing
fc={};
fs={};
tt={};

lambdas=[0,pow2(0:10)/100];

%"OBJECT-ORIENTED"
w=P3Workflow(p3train, @trainTestSplitMx, {17});
w=addFunction(w, 'featsCompute',    @featsComputePassThrough);  fc{end+1}='pass-through';
w=addFunction(w, 'featsSelect',     @featsSelectPassThrough);   fs{end+1}='pass-through';

for(lambda = lambdas)
    w=addFunction(w, 'trainTest', @ClassifierLogReg, 400, lambda); tt{end+1}=sprintf('LogReg (lambda=%.3f)',lambda);
endfor;

printf('launching workflow...'); fflush(stdout);
summary=launch(w);

summarize(summary, fc, fs, tt);