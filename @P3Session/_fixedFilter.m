%% ######################################################################
%% signal bandpassing with fixed filter parameters
%% to be used when loading signal and converting to a P3Session object
%% args: signal, sampling frequency
%% ######################################################################
function X = _fixedFilter(signal, sf)
    [b, a] = butter(2, [0.1/(0.5*sf), 10/(0.5*sf)]);
    X=filtfilt(b, a, signal);
endfunction;