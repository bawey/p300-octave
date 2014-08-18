%%
%	Leaves only the channels indicated in.
%
%
%%
function [mask] = featsSelectPickChannels(tfeats, tlabels, samplesPerChannel, channelsToKeep)
	start_idx=vec(channelsToKeep-1).*samplesPerChannel+1;
	mask=vec(linspace( start_idx ,start_idx+samplesPerChannel-1,samplesPerChannel)');
endfunction;