load ../p3data/p3tt-berlin3a.12fold.oct
init();
p3train=groupEpochs(p3train); p3test=groupEpochs(p3test);
starttime = cputime; [score, ans]=testBerlin(p3train, p3test, teststring, {@ClassifierLogReg, 150, 1}); printf('got %.2f and took %.2f CPU time \n', score, cputime-starttime);