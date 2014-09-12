%       just a set of commands for copy-pasting.

%function flowtest(dataFile, cvSplits, grouped=false, title='untitled', classifiers='all')

flowtest('~/Forge/p3data/p3tt-berlin2.12fold.oct', 42, true, 'Berlin2.Grouped');
flowtest('~/Forge/p3data/p3tt-berlin2.12fold.oct', 42, false, 'Berlin2.Loose', 'fast');
flowtest('~/Forge/p3data/p3tt-berlin2.12fold.oct', 42, false, 'Berlin2.Loose', 'slow');

%  
flowtest('~/Forge/p3data/p3tt-berlin3a.12fold.oct', 85, false, 'Berlin3a.Loose', 'fast');
flowtest('~/Forge/p3data/p3tt-berlin3a.12fold.oct', 85, false, 'Berlin3a.Loose', 'slow');

flowtest('~/Forge/p3data/p3tt-berlin3b.12fold.oct', 85, true, 'Berlin3b.Grouped');
flowtest('~/Forge/p3data/p3tt-berlin3b.12fold.oct', 55, false, 'Berlin3b.Loose', 'fast');
flowtest('~/Forge/p3data/p3tt-berlin3b.12fold.oct', 55, false, 'Berlin3b.Loose', 'slow');


%for asus (serial processing):


flowtest('~/Forge/p3data/p3tt-berlin3a.12fold.oct', 5, false, 'Berlin3a.Loose', 'fast');
flowtest('~/Forge/p3data/p3tt-berlin3b.12fold.oct', 5, false, 'Berlin3b.Loose', 'fast');
flowtest('~/Forge/p3data/p3tt-berlin2.12fold.oct', 7, false, 'Berlin2.Loose', 'fast');
flowtest('~/Forge/p3data/p3tt-berlin2.12fold.oct', 21, true, 'Berlin2.Grouped');

%for mac (parallel):

flowtest('berlin3a.oct', 17, false, 'tuned_Berlin3a.Loose', 'slow'); flowtest('berlin3b.oct', 17, false, 'tuned_Berlin3b.Loose', 'slow');flowtest('berlin2.oct', 21, false, 'tuned_Berlin2.Loose', 'slow');

flowtest('~/Forge/p3data/p3tt-berlin3a.12fold.oct', 17, true, 'Berlin3a.Grouped', 'fast');
flowtest('~/Forge/p3data/p3tt-berlin3b.12fold.oct', 17, true, 'Berlin3b.Grouped', 'fast');


init();
load('p3tt-berlin2.12fold.oct');
flowtest('~/Forge/p3data/p3tt-berlin2.12fold.oct', 42, true, 'balanced_42cv_Berlin2.Grouped');

