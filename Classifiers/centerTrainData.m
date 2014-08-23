function [train_data, tr_mean, tr_std] = centerTrainData(train_data)
    tr_mean=mean(train_data);
    tr_std=std(train_data);
    
    train_data=(train_data-tr_mean)./tr_std;
endfunction;