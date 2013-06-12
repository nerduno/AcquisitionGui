%this is a continuation of runSimulations.m
%
%--- plotting of result  --- only interesting for comparison with other algorithms (wave_clus and klustakwik
%

simNrs=[1 2 3];
for kk=1:length(simNrs)

    simNr = simulationToRun;

    %--- plot
    
    load(['resultsS' num2str(simNr) '.mat']);
    load(['results-klusta-S' num2str(simNr) '.mat']);
    load(['results-wave-S' num2str(simNr) '.mat']);

    load(['results-waveOrig-S' num2str(simNr) '.mat']);

    %since they have same detection method, use same detection count
    perfKlustaOrig=perfWaveOrig;
    perfApproxOrig=perfWaveOrig;

    
    %exact method has separate count
    load(['resultsSOrig' num2str(simNr) '.mat']);
    
    
    %perfAll = {perfChi2, perfNorm};
    %figSimulationPerformance( perfAll, {'Chi2','Approx'}, ['Simulation ' num2str(simNr)] );
    
    
    maxNrClusters=3;
    if simNr==3
        maxNrClusters=5;
    end
    
    perfAll2 = {perfAll{1}, perfAll{2}, perfKlusta,perfWave};
    perfOrig = {perfChi2Orig,perfApproxOrig,perfKlustaOrig,perfWaveOrig};
    
    figSimulationPerformance( perfAll2, perfOrig, {'thr exact','thr approximation','Offline 1','Offline 2'}, ['Simulation ' num2str(simNr)] , maxNrClusters);

    %calc misses
end