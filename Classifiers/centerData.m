function [train, test, center, spread] = centerData(train, test)

	center=(max(train).-min(train))./2;
	spread=(max(train).-min(train));

	train=(train.-center)./spread;
	test=(test.-center)./spread;

endfunction;