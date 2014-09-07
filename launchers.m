%       just a set of commands for copy-pasting.

%function flowtest(dataFile, cvSplits, grouped=false, title='untitled', classifiers='all')

flowtest('~/Forge/p3data/p3tt-berlin2.12fold.oct', 21, true, 'Berlin2.Grouped');
flowtest('~/Forge/p3data/p3tt-berlin2.12fold.oct', 7, false, 'Berlin2.Loose', 'fast');
flowtest('~/Forge/p3data/p3tt-berlin2.12fold.oct', 7, false, 'Berlin2.Loose', 'slow');

%  
flowtest('~/Forge/p3data/p3tt-berlin3a.12fold.oct', 5, false, 'Berlin3a.Loose', 'fast');
flowtest('~/Forge/p3data/p3tt-berlin3a.12fold.oct', 5, false, 'Berlin3a.Loose', 'slow');

%flowtest('~/Forge/p3data/p3tt-berlin3b.12fold.oct', 17, true, 'Berlin3b.Grouped');
flowtest('~/Forge/p3data/p3tt-berlin3b.12fold.oct', 5, false, 'Berlin3b.Loose', 'fast');
flowtest('~/Forge/p3data/p3tt-berlin3b.12fold.oct', 5, false, 'Berlin3b.Loose', 'slow');


%for asus (serial processing):


flowtest('~/Forge/p3data/p3tt-berlin3a.12fold.oct', 5, false, 'Berlin3a.Loose', 'fast');
flowtest('~/Forge/p3data/p3tt-berlin3b.12fold.oct', 5, false, 'Berlin3b.Loose', 'fast');
flowtest('~/Forge/p3data/p3tt-berlin2.12fold.oct', 7, false, 'Berlin2.Loose', 'fast');
flowtest('~/Forge/p3data/p3tt-berlin2.12fold.oct', 21, true, 'Berlin2.Grouped');

%for mac (parallel):

flowtest('~/Forge/p3data/p3tt-berlin2.12fold.oct', 7, false, 'Berlin2.Loose', 'slow');
flowtest('~/Forge/p3data/p3tt-berlin3a.12fold.oct', 5, false, 'Berlin3a.Loose', 'slow');
flowtest('~/Forge/p3data/p3tt-berlin3b.12fold.oct', 5, false, 'Berlin3b.Loose', 'slow');

flowtest('~/Forge/p3data/p3tt-berlin3a.12fold.oct', 17, true, 'Berlin3a.Grouped', 'fast');
flowtest('~/Forge/p3data/p3tt-berlin3b.12fold.oct', 17, true, 'Berlin3b.Grouped', 'fast');