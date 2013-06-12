
%
%does detection standalone
%prewhiten: 0/1. prewhiten of the raw signal,before extraction of spikes.
%alignMethod: 1 (pos), 2 (neg), 3 (mixed)
%
%
function handles = StandaloneInit( handles , tillBlocks, prewhiten, alignMethod )

handles = initFilter(handles);

    [timestamps,nrBlocks,nrSamples,sampleFreq,isContinous,headerInfo] = getRawCSCTimestamps( handles.rawFilename );
    handles.nrSamples=nrSamples;

    %display some statistics about this file
    headerInfo
	sessionDuration=(timestamps(end)-timestamps(1))/1000;
	%set(handles.labelDuration,'String',num2str(sessionDuration));
	l='yes';
	if ~isContinous
        l='no';
	end
	%set(handles.labelContinous,'String',l);
	%set(handles.labelBlocks, 'String', num2str(nrSamples));
	%set(handles.labelFilename,'String',handles.rawFilename);
	
	%tillBlocks = str2num(get(handles.fieldBlocks,'String')); %if 999=till 1000 spikes were detected
	
	%tillBlocks=1000;
	
	includeRange=[];
	if exist(handles.includeFilename)==2
        %set(handles.fieldRangeFileUsed,'String',[handles.includeFilename]);
        includeRange = dlmread(handles.includeFilename);
        ['include range is set from ' handles.includeFilename]
    else
        %set(handles.fieldRangeFileUsed,'String',['None']);
	end
	
	
	%detection
 
    [allSpikes, allSpikesNoiseFree, allSpikesCorrFree, allSpikesTimestamps, dataSamplesRaw,filteredSignal, rawMean,rawTraceSpikes,runStd2,upperlim,stdEstimates, blocksProcessed, noiseTraces] = processRaw(handles.rawFilename, handles.nrSamples, handles.Hd, tillBlocks,1,includeRange,handles.paramExtractionThreshold, prewhiten, alignMethod );
    

    %[allSpikesPositive,allSpikesNegative, allSpikesTimestampsPositive,allSpikesTimestampsNegative,dataSamplesRaw,filteredSignal, rawMean,rawTraceSpikes,runStd2,upperlim,stdEstimates,blocksProcessed, positiveRaw, negativeRaw, noiseAutocorr]  
	
    handles.blocksProcessedForInit=blocksProcessed;
	handles.dataSamplesRaw=dataSamplesRaw;
	handles.rawMean=rawMean;
	handles.rawTraceSpikes=rawTraceSpikes;
	handles.runStd2=runStd2;
	handles.upperlim=upperlim;
	handles.filteredSignal=filteredSignal;
    handles.noiseTraces=noiseTraces;
    
	handles.stdEstimateOrig = calculateStdEstimate(stdEstimates); %mean(stdEstimates);

	['std estimate is ' num2str(handles.stdEstimateOrig)]
    

        handles.allSpikesNegative=allSpikes;
        handles.allSpikesTimestampsNegative=allSpikesTimestamps;
        handles.newSpikesNegative=allSpikes;
        handles.newSpikesTimestampsNegative=allSpikesTimestamps;
        handles.spikesSolvedNegative=allSpikes;    
        handles.allSpikesNoiseFree=allSpikesNoiseFree;
        handles.allSpikesCorrFree=allSpikesCorrFree;
 
        %for compatibility reasons
        handles.allSpikesPositive=[]; 
	    handles.allSpikesTimestampsPositive=[];
        handles.newSpikesPositive=[];
        handles.newSpikesTimestampsPositive=[];
        handles.spikesSolvedPositive=[];       

        
%     'filtering and RBF'
%     if size(allSpikesPositive,1)>0
%         [spikesSolvedPositive, newSpikesPositive, newTimestampsPositive] = filterAndRBF(allSpikesPositive,allSpikesTimestampsPositive,handles.stdEstimateOrig, 1);
%         handles.allSpikesPositive=newSpikesPositive; 
% 	    handles.allSpikesTimestampsPositive=newTimestampsPositive;
%         handles.newSpikesPositive=newSpikesPositive;
%         handles.newSpikesTimestampsPositive=newTimestampsPositive;
%         handles.spikesSolvedPositive=spikesSolvedPositive;
%     else
%     end
%     
%     if size(allSpikesNegative,1)>0
%         [spikesSolvedNegative, newSpikesNegative, newTimestampsNegative] = filterAndRBF(allSpikesNegative,allSpikesTimestampsNegative,handles.stdEstimateOrig, 2);
%         handles.allSpikesNegative=newSpikesNegative;
%         handles.allSpikesTimestampsNegative=newTimestampsNegative;
%         handles.newSpikesNegative=newSpikesNegative;
%         handles.newSpikesTimestampsNegative=newTimestampsNegative;
%         handles.spikesSolvedNegative=spikesSolvedNegative;
%     else
%         handles.allSpikesNegative=[];
%         handles.allSpikesTimestampsNegative=[];
%         handles.newSpikesNegative=[];
%         handles.newSpikesTimestampsNegative=[];
%         handles.spikesSolvedNegative=[];
%         
%     end
    
    %store filtered versions (of orig spikes)


    
    %store solved versions too
    
	%set(handles.labelNrPositive, 'String', ['Orig:' num2str( size(handles.allSpikesPositive,1)) '/ Filtered:' num2str( size(handles.spikesSolvedPositive,1))]);
	%set(handles.labelNrNegative, 'String', ['Orig:' num2str( size(handles.allSpikesNegative,1)) '/ Filtered:' num2str( size(handles.spikesSolvedNegative,1))]);
    

handles.stdEstimate = handles.stdEstimateOrig*handles.correctionFactorThreshold;
['std estimate corrected is ' num2str(handles.stdEstimate)]


'init finished'
