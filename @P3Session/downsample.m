function p3d=downsample(p3s, factor)
	copysignal=p3s.signal;
	target_columns_cnt = columns(copysignal)/factor;
	tempsignal=repmat(NaN, rows(copysignal), target_columns_cnt);
	
	target_columns_per_channel=ceil(columns(tempsignal)/p3s.channelsCount);

    for(cnl=1:p3s.channelsCount)
        
        % mask for columns related to current channel
        cols = channelColumnsSelector(p3s, cnl);
        channel_signal = copysignal(:,cols);
        
        % reshape into a single vector (octave takes column after column, hence the transposition)
        channel_signal = reshape(channel_signal', 1, numel(channel_signal));
        channel_signal = decimate(channel_signal, factor);
        
        % reshape back. achtung: octave fills columns first. hence the dimensions are swapped and the whole thing transposed
        channel_signal = reshape(channel_signal,target_columns_per_channel,rows(copysignal))';
        
        %fit into the destination matrix
        tempsignal(:,(1:target_columns_per_channel)+(cnl-1)*target_columns_per_channel)=channel_signal;
    endfor;


    assert(sum(isnan(tempsignal(:)))==0)

	p3d=P3Session(tempsignal, p3s.stimuli, p3s.targets, p3s.channelsCount, p3s.samplingRate/factor, p3s.channelNames);
endfunction;


%   The former approach of decimating individual responses separately:
%
%      for(i=1:size(p3s.signal,1))
%  %       tempperiod=zeros(1, size(tempsignal, 2));
%          for(j=1:p3s.channelsCount)
%              %tempperiod(1, [1:target_columns_per_channel]+target_columns_per_channel*(j-1))=[decimate(copysignal(i,channelColumnsSelector(p3s, j)), factor)];
%              tempsignal(i, [1:target_columns_per_channel]+target_columns_per_channel*(j-1))=[decimate(copysignal(i,channelColumnsSelector(p3s, j)), factor)];
%          endfor;
%  %       tempsignal(i, :)=tempperiod;
%  %          if(rand()>0.95)
%  %              printf('progress %.2f%% \r', i/size(p3s.signal,1)*100); fflush(stdout);
%  %          endif;
%      endfor;