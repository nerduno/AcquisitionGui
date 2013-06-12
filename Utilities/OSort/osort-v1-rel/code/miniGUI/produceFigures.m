function produceFigures(handles, outputpath,outputFormat, thresholdMethod, noProjectionTest, exportFigures)
if nargin==4
	noProjectionTest=false;
    exportFigures=true;
end

colors={'r','g','b','k','y','m','c','r','g','b','k','y','m','c','r','g','b','k','y','m','c'};
paperPosition=[0 0 16 12];

figure(123);
close(gcf);


if thresholdMethod==1
    rawWaveforms = handles.newSpikesNegative;
else
    %if sorting was done using whitened waveforms,use them for plotting 
    rawWaveforms = handles.allSpikesCorrFree;
end

outputOption = ['-d' outputFormat];
if outputFormat=='eps'
	outputOption = [ outputOption 'c2'];
end

outputEnding = [ '.' outputFormat];

clusters=handles.useNegative;
if length(clusters)>length(colors)
    clusters=clusters(1:length(colors));
end

%first clusters are the biggest clusters
clusters = flipud( clusters );
nrClusters=length(clusters);

if exist(outputpath)==0
	mkdir(outputpath);
end

for i=1:length(clusters)
    cluNr=clusters(i);
    disp(['Figure for cluster nr ' num2str(cluNr)]);
    
    figure(cluNr);
    plotSingleCluster(rawWaveforms, handles.newSpikesTimestampsNegative, handles.assignedClusterNegative, [handles.label '(-)'],  cluNr, colors{i});
    scaleFigure;
    set(gcf,'PaperUnits','inches','PaperPosition',paperPosition)
    if exportFigures
        print(gcf,outputOption,[outputpath handles.prefix handles.from '_CL_' num2str(cluNr) '_THM_' num2str(thresholdMethod) outputEnding  ]);
        close(gcf);
    end
end

disp(['figure sorting result all']);
figure(8888)
plotSortingResultRaw(rawWaveforms, [], handles.assignedClusterNegative, [], clusters, [], [handles.label '(-)'], colors )    
scaleFigure;
set(gcf,'PaperUnits','inches','PaperPosition',paperPosition)

if exportFigures
    print(gcf,outputOption,[outputpath handles.prefix handles.from '_CL_ALL' '_THM_' num2str(thresholdMethod) outputEnding]);
    close(gcf);
end

%disp(['figure sorting result noise free spikes']);
%figure(889)
%plotSortingResultRaw(handles.allSpikesCorrFree, [], handles.assignedClusterNegative, [], handles.useNegative, [], [handles.label '(-)'] )        
%scaleFigure;
%set(gcf,'PaperUnits','inches','PaperPosition',paperPosition)
%print(gcf,outputOption,[outputpath handles.prefix handles.from '_CL_ALL_noiseFree' outputEnding  ]);
%close(gcf);

if length(clusters)==0
    return;
end

%--
%---- PCA figure      
figure(123);
[pc,score,latent,tsquare] = princomp(rawWaveforms);

assigned=handles.assignedClusterNegative;

plotInds=[];
allInds=[];
for i=1:length(clusters)
    cluNr=clusters(i);
    plotInds{i} = find( assigned == cluNr );
    allInds=[allInds plotInds{i}];
end
noiseInds=setdiff(1:length(assigned),allInds);

plot( score(noiseInds,1), score(noiseInds,2), '.', 'color', [0.5 0.5 0.5]);
hold on
for i=1:nrClusters
    plot( score(plotInds{i},1), score(plotInds{i},2), [colors{i} '.']);
end
hold off

%focus on the data,not the noise
xlim([ 0.9*min(score(allInds,1)) 1.1*max(score(allInds,1))]);
ylim([ 0.9*min(score(allInds,2)) 1.1*max(score(allInds,2))]);


stdWaveforms=mean(std(handles.allSpikesCorrFree));
title(['PC1/PC2, whitened std=' num2str(stdWaveforms)]);
scaleFigure;
set(gcf,'PaperUnits','inches','PaperPosition',paperPosition)
if exportFigures
    print(gcf, outputOption, [outputpath handles.prefix handles.from '_PCAALL_THM_' num2str(thresholdMethod) outputEnding ]);
    close(gcf);
end

if noProjectionTest
	return;
end

%--
%--- significance test between all clusters
pairs=[];
pairsColor=[];
c=0;

%only for the 7 biggest to avoid lots of useless plots
if nrClusters>7
    nrClusters=7;
end

for i=1:nrClusters
	for j=i+1:nrClusters
		c=c+1;
		pairs(c,1:2)=[clusters(i) clusters(j)];
		pairsColor(c,1:2)=[i j];
	end
end

for i=1:size(pairs,1)
	figure(123+i)
	disp(['figure cluster pair ' num2str(i) ' ' num2str(pairs(i,:))]);
	figureClusterOverlap( handles.allSpikesCorrFree, rawWaveforms, handles.assignedClusterNegative, pairs(i,1),pairs(i,2), handles.label,1,{colors{pairsColor(i,1)}, colors{pairsColor(i,2)}} );
	scaleFigure;
    set(gcf,'PaperUnits','inches','PaperPosition',paperPosition)
    if exportFigures
        print(gcf, outputOption, [outputpath handles.prefix handles.from '_SepTest_' num2str(pairs(i,1)) '_' num2str(pairs(i,2)) '_THM_' num2str(thresholdMethod) outputEnding ]);
        close(gcf);
    end
end

%if there is only one: print distribution in any case
if size(pairs,1)==0 && length(clusters)==1
	figure(1230);
	figureClusterOverlap( handles.allSpikesCorrFree, rawWaveforms, handles.assignedClusterNegative, clusters(1), 0, handles.label,1, {colors{1}, colors{2}} );
	scaleFigure;
	set(gcf,'PaperUnits','inches','PaperPosition',paperPosition)
    if exportFigures
        print(gcf, outputOption, [outputpath handles.prefix handles.from '_SepTest_' num2str(clusters(1)) '_' num2str(clusters(1)) '_THM_' num2str(thresholdMethod) outputEnding ]);
        close(gcf);
    end
end


