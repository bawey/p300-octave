cvalues=[1000, 100, 10, 5, 1, 0.5, 0.1, 0.05, 0.01];
gammas=[0.0001 0.0005 0.001 0.05 0.01 0.1 1];
lambdas=[0 0.001 0.01 0.1 1 10];

max_iterations_values=[125];
hidden_neurons_values=[32];    

fprintf('{@DummyClassifier}\n');
for(c=cvalues)
    fprintf(sprintf('{@ClassifierNan, struct("TYPE", "SVM", "hyperparameter", struct("c_value", %f))}\n', c));
endfor;

for(gamma=gammas)
    fprintf(sprintf('{@ClassifierNan, struct("TYPE", "FLDA", "hyperparameter", struct("gamma", %f))}\n', gamma));
endfor;

for(lambda = lambdas)
    for(max_iterations=max_iterations_values)
        fprintf(sprintf('{@ClassifierLogReg, %d, %f}\n', max_iterations, lambda));
    endfor;
endfor;    

for(lambda=lambdas(3:end))
    for(hidden_neurons = hidden_neurons_values)
        for(max_iterations = max_iterations_values)
            fprintf(sprintf('{@ClassifierNN, %d, %d, %f}\n', hidden_neurons, max_iterations, lambda));
        endfor;
    endfor;
endfor;