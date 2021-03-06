%READS FROm THE FILES PROVIDED
function p3Session = P3SessionBerlin(varargin)
	
	epoch_length=192;
	
	eeg=[]
	stimuli=[];
	targets=[];
	
	for(path = varargin)
		if(~ischar(path))
			path=path{:};
			printf('Simple cell-to-string hopefully and ...')
		endif;
		printf('Now we read the matrix from file: %s', path); fflush(stdout);
		load(path);
		printf('... done! \n'); fflush(stdout);
		%signal - all our raw signal, needs a predefined bandpassing. should be done on a period-by-period basis,
		%but with intervals large enough between the sessions, bandpassing all will also be fine. and faster.
		for(c=1:columns(signal))
            %fixed filter returns a row and accepts a row
            %signal(:, c)=_fixedFilter(signal(:,c)',240)';
		endfor;
		
		
		%All is loaded. We do not care (pErr detection is tough) what happened when the screen was black etc.
		%We want to get responses to stimuli
		
		%We need to know: when a stimulus was flashed
		%When we have an index of sample shown when it flashed, we get N next samples, transpose and we have our response
		
		
		%Get all indices of samples gathered while a row(7..12) or a column (1..6) was highlighted
		flashedSampleIdx=find(StimulusCode~=0);
		
		%Get only the first such index for each 100ms intensification:
		%2. we need to know when each intesification began, marking the start of each epoch
		%There should be exactly 12*15*numberOfPeriods of such epochStarts
		epochStartIdx=flashedSampleIdx(flashedSampleIdx(2:end,:)-flashedSampleIdx(1:end-1,:)>1);
		if(mod(length(epochStartIdx), 180)~=0)
            %sometimes we get one extra, sometimes one too few. trying to hack it working.
            epochStartIdx=flashedSampleIdx(flashedSampleIdx(1:end,:)-[0; flashedSampleIdx(1:end-1,:)]>1);
		endif;
		assert(mod(length(epochStartIdx), 180)==0, sprintf('epochStartIdx of length %d', length(epochStartIdx)));
		
		%our epoch length will be 192, as 192/240=0.8 sec.
		epochEndIdx=epochStartIdx+epoch_length-1;
				
		%pre-allocate a chunk for filename contents
        eeg=[eeg; zeros(length(epochStartIdx), epoch_length*64)];
        
        for(epochNo=1:length(epochStartIdx))
            epoch=signal(epochStartIdx(epochNo):epochEndIdx(epochNo), :);
            %each row is a separate epoch, column blocks are for electrodes, columns in block represent values at time t0, t1... tN
            %fill the part preallocated above
            eeg(end-length(epochStartIdx)+epochNo, :)=reshape(epoch, 1, columns(epoch)*rows(epoch));
        endfor;
		
		
		%....The stimuli
		stimuli_temp=StimulusCode(StimulusCode~=0);
		%columns (1..6) are mapped to (-1..-6)
		stimuli_temp.*=sign((stimuli_temp<7)*-1+0.5);
		%rows (7..12) are mapped (to 1..6)
		stimuli_temp.-=(stimuli_temp>6)*6;
		%this contains lots of entries per stimuli (well, 100ms at 240Hz - 24 entries).
		stimuli=[stimuli; reshape(stimuli_temp, 24, length(stimuli_temp)/24)'(:,1)];
		
		if(exist('StimulusType'))
			%...The targets
			%We'll pull out the same trick: we will look forStimulusType's preceeded by sth else
			allLabels = StimulusCode(find(StimulusType==1 & StimulusType~=[0;StimulusType(1:end-1)]));
			%it's still coded the original way... recoding
			colLabels=allLabels(allLabels<7)*-1;
			rowLabels=allLabels(allLabels>6)-6;
			%take every 15th entry()
			%achtung! here comes a drirty hack for a rare case (one file) with 16-15-15 intensifications that would break the %15 logic
			colLabelsTemp=colLabels(mod(1:length(colLabels),15)==1);
			rowLabelsTemp=rowLabels(mod(1:length(rowLabels),15)==1);
			if(length(rowLabelsTemp)>length(colLabelsTemp))
                rowLabelsTemp=rowLabels(mod(1:length(rowLabels),16)==1);
			endif;
			if(length(colLabelsTemp)>length(rowLabelsTemp))
                colLabelsTemp=colLabels(mod(1:length(colLabels),16)==1);
            endif;
            rowLabels=rowLabelsTemp;
            colLabels=colLabelsTemp;
			%store targets: done!
			targets=[targets;rowLabels, colLabels];
		else
			targets=zeros(rows(eeg)/(15*12),2);
		endif;
	endfor;
	
	channelNames={ 'FC5','FC3','FC1','FCZ','FC2','FC4','FC6', 'C5', 'C3', 'C1', 'CZ', 'C2', 'C4', 'C6', 'CP5', 'CP3', 'CP1', 'CPZ', 'CP2', 'CP4', 'CP6', 'Fp1', 'FpZ', 'Fp2', 'AF7', 'AF3', 'AFZ', 'AF4', 'AF8', 'F7', 'F5', 'F3', 'F1', 'FZ', 'F2', 'F4', 'F6', 'F8', 'FT7', 'FT8', 'T7', 'T8', 'T9', 'T10', 'TP7', 'TP8', 'P7', 'P5', 'P3', 'P1', 'PZ', 'P2', 'P4', 'P6', 'P8', 'PO7', 'PO3', 'POZ', 'PO4', 'PO8', 'O1', 'OZ', 'O2', 'IZ' };
	
	%and this is needed to be passed as a parent. and as an object.
		p3Session = P3Session(eeg, stimuli, targets, 64, 240, channelNames);
endfunction;