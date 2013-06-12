%
%detect spikes from simulated spiketrain
%
function [filteredSignal, rawTraceSpikes,spikeWaveforms, spikeTimestamps, runStd2,upperlim,noiseTraces] = detectArtificialSpikes( spiketrainDown, extractionThreshold ) 



rawSignal = spiketrainDown';

%setup filter
n = 4; 
Wn = [300 3000]/(25000/2);
[b,a] = butter(n,Wn);
HdNew=[];
HdNew{1}=b;
HdNew{2}=a;

nrNoiseTraces=10000;


[rawMean, filteredSignal, rawTraceSpikes,spikeWaveforms, spikeTimestamps, runStd2, upperlim, noiseTraces] = extractSpikes(rawSignal, HdNew, extractionThreshold, nrNoiseTraces, 0, 3); % 0->no prewhitening, 3->align mixed

