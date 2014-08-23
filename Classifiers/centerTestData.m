function test_data = centerTestData(test_data, tr_mean, tr_std)
    test_data=(test_data-tr_mean)./tr_std;
endfunction;