%
%produces a figure of the raw data traces and saves it in a file 
%
%urut/feb05
%
function handles = produceRawTraceFig( handles , figPath )

    if exist(figPath)==0
        mkdir(figPath);
    end

handles = initFilter(handles);

    [timestamps,nrBlocks,nrSamples,sampleFreq,isContinous,headerInfo] = getRawCSCTimestamps( handles.rawFilename );
    handles.nrSamples=nrSamples;

    %display some statistics about this file
    headerInfo
	
    tillBlocks=5;
    includeRange=[];

    %since we arent interested in spikes,following 2 params dont matter for this task 
    prewhiten=0;
    alignMethod=1;

    [allSpikes, allSpikesNoiseFree, allSpikesCorrFree, allSpikesTimestamps, dataSamplesRaw,filteredSignal, rawMean,rawTraceSpikes,runStd2,upperlim,stdEstimates, blocksProcessed, noiseTraces] = processRaw(handles.rawFilename, handles.nrSamples, handles.Hd, tillBlocks,1,includeRange,handles.paramExtractionThreshold,prewhiten, alignMethod);
    
    figure(888);
    plotSpikeExtraction([handles.prefix handles.from ' B' num2str(tillBlocks) ' T=' num2str(handles.paramExtractionThreshold)],dataSamplesRaw, rawMean, filteredSignal, rawTraceSpikes, runStd2, upperlim);

    scaleFigure;
    print(gcf,'-dpng',[figPath handles.prefix handles.from '_B' num2str(tillBlocks) '_RAW.png' ]);
    close(gcf);




'init finished'
