%transforms a P3Session object with no labels into a full P3Session using the labels information (string)

function p3session = P3SessionAddLabels(p3test, teststring)
    targets=[];
    for(periodNo=1:p3test.periodsCount)
        [row, col] = charCoords(teststring(periodNo));
        target = [row,col];
        targets=[targets; target];
    endfor;
    
    p3session=P3Session(p3test.signal, p3test.stimuli, targets, p3test.channelsCount, p3test.samplingRate, p3test.channelNames);
endfunction;