function [train, test, tr_mean, tr_std] = centerData(train, test)

    tr_mean=mean(train);
    tr_std=std(train);
    
    train=(train-tr_mean)./tr_std;
    test=(test-tr_mean)./tr_std;

endfunction;