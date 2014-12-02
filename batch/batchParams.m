raws=struct();
raws.berlin2 = '~/Copy/eeg_old/berlin.bci.ii';
raws.berlin3a = '~/Copy/eeg_old/berlin.bci.iii';
raws.berlin3b = '~/Copy/eeg_old/berlin.bci.iii';

dirBinaryData = '~/Forge/p3data/';
decimationFactor = 16;

binNames = struct();
binNames.berlin2 = 'p3tt-berlin2';
binNames.berlin3a = 'p3tt-berlin3a';
binNames.berlin3b = 'p3tt-berlin3b';

datasets={'berlin2', 'berlin3a', 'berlin3b'};

minXvRate = 10;
classification_methods='dummy';
balancing = 'no';

dirSummaries = '~/Desktop/eeg/';