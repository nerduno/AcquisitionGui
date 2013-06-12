%
%this is the main file for the command line user interface
%all relevant parameters are set in here
%
%urut/feb06
%----

basePath='/home/urut/code/osort-v1-rel/data/';
pathOut='/home/urut/code/osort-v1-rel/data/sort/'

pathRaw=[basePath ];
pathFigs=[basePath '/figs/'];
patientID='P3 S1';      % label for figures

filesToProcess=[12];   %which channels to process -- can be multiple, array
groundChannels=[];
filesToProcess=setdiff(filesToProcess,groundChannels);

extractionThreshold=5.5;      % extraction threshold to use. 
thres         =[repmat(extractionThreshold, 1, length(filesToProcess))];

tillBlocks=500;
doDetection=1;    % do detection yes/no
doSorting=1;      % do sorting yes/no
doFigures=1;      % produce figures yes/no
noProjectionTest=0; % switch off production of projection test figures
doRawGraphs=1;      % produce a figure of parts of the raw data (this is separate from the sorting,raw file is read again for this)
thresholdMethod=1; %1=approx, 2=exact
prewhiten=0; %0=no, 1=yes,whiten raw signal (dont)
alignMethod=3;  %1=max, 2=min, 3=mixed

exportFigures=0;  %0-> no, display on screen. 1-> yes, store to png file (much faster)
outputFormat='png';   %export format,only relevant if exportFigures=1


StandaloneGUI;

