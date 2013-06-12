%
%automatically processes all files as set in the graphical or text mode userinterface
%
%urut/feb06


starttime=clock;

%automatic from here on
%-------------------------------------------------------------------
%-------------------------------------------------------------------

%for currentThresInd=1:length(thres)
timeSortingStats=[]; %i time nrSpikesSorted
timeDetectionStats =[];%i time duration(in blocks of 512000 samples)

pathOutOrig=pathOut;

for kkk=1:length(filesToProcess)

    i = filesToProcess(kkk);

    currentThresInd=kkk;

    handles=[];

    handles.correctionFactorThreshold=0;  %minimal threshold, >0 makes threshold bigger
    handles.paramExtractionThreshold=thres(currentThresInd);

    pathOut = [ pathOutOrig '/' num2str(handles.paramExtractionThreshold) '/'];

    if exist(pathOut)==0
        ['creating directory ' pathOut]
        mkdir(pathOut);
    end


    handles.rawFilename=[pathRaw 'A' num2str(i) '.Ncs'];
    if doDetection

        if exist(handles.rawFilename)==0
            ['file does not exist, skip ' handles.rawFilename]
            continue;
        end

        handles.includeFilename=[basePath 'timestampsInclude.txt'];

        starttimeDetection=clock;
        handles = StandaloneInit( handles , tillBlocks, prewhiten, alignMethod );
        timeDetection = abs(etime(starttimeDetection,clock))

        timeDetectionStats(size(timeDetectionStats,1)+1,:) = [ i timeDetection handles.blocksProcessedForInit];



        handles.filenamePrefix = [pathOut 'A' num2str(i)];
        GUIstoreResult( [], handles, 2 , 2 );%2==no figures, 2=noGUI
    end


    starttimeSorting=clock;
    if exist('doRawGraphs')==1
        if doRawGraphs && exist(handles.rawFilename)>0
            handles.prefix='A';
            handles.from=num2str(i);
            produceRawTraceFig(handles, [pathFigs num2str(thres(currentThresInd)) '/']);
        end
    end

    if doSorting || doFigures
        handles.basepath=pathOut;
        handles.prefix='A';
        handles.from=num2str(i);
        [handles,fileExists] = GUIloadFromFile([],handles, 2);
        handles.filenamePrefix=[pathOut 'A' num2str(i)];

        if fileExists==0
            ['File does not exist: ' handles.filenamePrefix];
            continue;
        end

        if doSorting
            if size(handles.newSpikesNegative,1)>0
                starttimeSorting=clock;

                [handles] = GUISortOnline( [], handles, 2, thresholdMethod  ); %2=no GUI

                timeSorting=abs(etime(starttimeSorting,clock))
                timeSortingStats(size(timeSortingStats,1)+1,:) = [i timeSorting length(handles.assignedClusterNegative)];

                GUIstoreResult(  [], handles, 2, 2  );%2==no figures
            else
                'nothing to sort (0 spikes)'
            end
        end


        if doFigures
            handles.label=[ patientID ' ' handles.prefix handles.from ' Th:' num2str(thres(currentThresInd))];
            handles.label = strrep(handles.label,'_',' ');
            disp(['producing figure for ' handles.label]);

            produceFigures(handles, [pathFigs num2str(thres(currentThresInd)) '/'], outputFormat, thresholdMethod , noProjectionTest, exportFigures);
        end
    end
end
%end


etime(clock,starttime)
