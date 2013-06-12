%
%processes raw signal, extracts spikes. loads data directly from neuralynx
%file.
%
%filename: full path/name to neuralynx file
%totNrSamples: nr of samples in this file
%Hd: filter specification
%howManyBlocks: >0 do only so many blocks
%               0 : as many as there are
%startWithBlock: 1=start with first block
%                >1: dont process first x blocks
%includeRange: from/to timestamps of periods to sort. if empty everything
%is taken.
%
%extractionThreshold: how many times the running std of the energy signal
%to extract ?
%
%prewhiten: yes/no
%
%urut/april04
%
function [allSpikes, allSpikesNoiseFree, allSpikesCorrFree, allSpikesTimestamps, dataSamplesRaw,filteredSignal, rawMean,rawTraceSpikes,runStd2,upperlim,stdEstimates, blocksProcessed, noiseTraces] = processRaw(filename, totNrSamples, Hd, howManyBlocks, startWithBlock, includeRange, extractionThreshold, prewhiten, alignMethod )
%detect spikes
blocksize=512000;
runs = fix( totNrSamples/ blocksize ) + 1;

allSpikes=[];
allSpikesTimestamps=[];
allSpikesNoiseFree=[];
allSpikesCorrFree=[];

%returns data of last block processed -- for debugging purposes
dataSamplesRaw=[];
rawMean=[];
filteredSignal=[];
rawTraceSpikes=[];
runStd2=[];
upperlim=[];
stdEstimates=[];

noiseTraces=[];
nrNoiseSamplesToUse=50;

for i=startWithBlock:runs
    
    fromInd=(i-1)*blocksize+1;
    tillInd=i*blocksize;
    if tillInd>totNrSamples
        tillInd=totNrSamples;
    end
    
    disp(['run: ' num2str(i) ' of ' num2str(runs) ' ind from ' num2str(ceil(fromInd/512)) ' to ' num2str(tillInd/512)]);
    
    %load data from file
    t1=clock;
    [timestampsRaw,dataSamplesRaw] = getRawCSCData( filename, ceil(fromInd/512), tillInd/512 );
    disp(['time for raw read ' num2str(etime(clock,t1))]);
    
    if size(includeRange,1)>0
        includeMask=zeros(1, length(timestampsRaw));
        for j=1:size(includeRange,1)
            inds = find( timestampsRaw >= includeRange(j,1) & timestampsRaw <= includeRange(j,2) );
            if length(inds)>0
                includeMask(inds) = 1;
            end
        end
        
        if sum(includeMask)==0
            disp(['all samples in this block are excluded,skip from:' num2str(timestampsRaw(1),10) ' to:' num2str(timestampsRaw(end),10)]);
            continue;
        else
            if sum(includeMask)<length(timestampsRaw)
                %only some are excluded
                disp(['some samples are excluded from:' num2str(timestampsRaw(1),10) ' to:' num2str(timestampsRaw(end),10)]);
            
                timestampsRaw = timestampsRaw( find(includeMask>0) );
                dataSamplesRaw = dataSamplesRaw( find(includeMask>0) );
            else
                disp(['all samples included. from:' num2str(timestampsRaw(1),10) ' to:' num2str(timestampsRaw(end),10)]);
            end
        end
    end

    t1=clock; 
    [rawMean, filteredSignal, rawTraceSpikes,spikeWaveforms, spikeTimestamps, runStd2, upperlim, noiseTracesTmp] = extractSpikes( dataSamplesRaw, Hd, extractionThreshold, nrNoiseSamplesToUse, prewhiten, alignMethod );
    disp(['time for extraction ' num2str(etime(clock,t1))]);

    stdEstimates(i) = std(filteredSignal);

    %save(['c:\temp\traces\traces_B' num2str(i) '.mat'],'filteredSignal','spikeWaveforms','noiseTracesTmp');
    
    %add to global storage of noise traces, adding block # into first
    %column
    if size(noiseTracesTmp,1)>1
        noiseTracesTmp2=[];
        noiseTracesTmp2(1:size(noiseTracesTmp,1) ,1) = ones( size(noiseTracesTmp,1), 1 )*i;
        noiseTracesTmp2(1:size(noiseTracesTmp,1),2:size(noiseTracesTmp,2)+1)=noiseTracesTmp;
        noiseTraces = [noiseTraces; noiseTracesTmp2];
    end
    
    %upsample and classification
    disp(['upsample and classify run ' num2str(i) ' nr spikes ' num2str(size(spikeWaveforms,1))]);

    
    %classify
    %[spikeWaveformsNegative, spikeTimestampsNegativeTmp,nrSpikesKilledNegative,killedNegative] = classifySpikes(-1 * spikeWaveformsNegative,spikeTimestampsNegative);
    
    %only denoise if enough traces available
    
    nrNoiseTraces=size(noiseTraces,1);
    disp(['nrNoiseTraces ' num2str(nrNoiseTraces)]);

    %store orig waveforms for later whitening. 
	transformedSpikes = spikeWaveforms;
        
    %upsample and re-align
    spikeWaveforms=upsampleSpikes(spikeWaveforms);
    spikeWaveforms = realigneSpikes(spikeWaveforms, spikeTimestamps, alignMethod, stdEstimates(i));  %3==type is negative, do not remove any if too much shift

    %convert timestamps
    spikeTimestampsTmp=spikeTimestamps;
    spikeTimestampsConverted = convertTimestamps( timestampsRaw, spikeTimestampsTmp );

    %put into global data structure
    allSpikes = [allSpikes; spikeWaveforms];
    allSpikesTimestamps = [allSpikesTimestamps spikeTimestampsConverted];
    allSpikesCorrFree = [ allSpikesCorrFree; transformedSpikes]; 

    disp(['== number of spikes found in run ' num2str(i) ' ' num2str( size(spikeWaveforms,1)) ' total ' num2str(size(allSpikes,1)) ]);
    
    %stop as soon as 1000 spikes were detected,positive and negative
    if howManyBlocks==999
        if size(allSpikes,1)>=1000 
            %&& size(allSpikesNegative,1)>=1000
            blocksProcessed=i;
            break;
        end
    end
    
    %stop early if limit is set (by caller of function)
    if howManyBlocks>0
        if i>=howManyBlocks            
            blocksProcessed=i;
            break;
        end
    end
end

blocksProcessed=i;

%whiten
if size(noiseTraces,1)>0
    [trans, transUp, corr, stdWhitened] = posthocWhiten(noiseTraces, allSpikesCorrFree, alignMethod);
    allSpikesCorrFree = transUp;    
    
    %only store the autocorrelation,not all noise traces
    noiseTraces=corr;
end
