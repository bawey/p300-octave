function rslt = allfactors(N)
%# Return all the integer divisors of the input N
%# If N = 0, return 0
%# If N < 0, return the integer devisors of -N
    if N == 0
        rslt = N;
        return
    end
    if N < 0
        N = -N;
    end

    x = factor(N)'; %# get all the prime factors, turn them into a column vector  '
    rslt = []; %# create an empty vector to hold the result
    for k = 2:(length(x)-1)
        rslt = [rslt ; unique(prod(nchoosek(x,k),2))];
    end
    rslt = sort([1 ; unique(x) ; rslt ; N])'; %# add in the trivial and prime factors, sort the list
end