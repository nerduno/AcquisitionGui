%extracts spikes from raw signal
%applies band-pass filtering to raw signal before doing so.
%
%nrNoiseTraces: 0 if no noise should be estimated
%               >0 : # of noise traces to be used to estimate autocorr of
%               noise, returned in variable autocorr
%
%urut/2004
function [rawMean, filteredSignal, rawTraceSpikes,spikeWaveforms, spikeTimestamps, runStd2, upperlim, noiseTraces] = extractSpikes(rawSignal, Hd,extractionThreshold, nrNoiseTraces, prewhiten, alignMethod )
%running mean raw signal
rawMean = runningAverage( rawSignal, 50);
filteredSignal = filterSignal( Hd,  rawSignal);

%calculate local energy
runStd2 = runningStd(filteredSignal, 18);  %5=0.2ms. use ~ 1ms , because thats a typical spike width
d0 = size(rawSignal,1) - size(runStd2,1);
end0 = runStd2(end);
runStd2(end:end+d0)=end0;

%---STD
upperlimFixed = mean( runStd2 ) + extractionThreshold * std(runStd2);    %extractionThreshold default is 5
upperlim=ones(length(runStd2),1)*upperlimFixed;

if prewhiten
          disp(['Prewhiten the signal - nr datapoints ' num2str(length(filteredSignal))]);	
          x= filteredSignal(1:500000);
          [a,e]=lpc(x,5);
          a=real(a);
          e=sqrt(e);
          filteredSignal2 = filter(a, e, filteredSignal );
end

nrNoiseTraces=900;
[rawTraceSpikes,spikeWaveforms, spikeTimestamps, noiseTraces] = detectSpikesFromPower(filteredSignal, rawMean, runStd2, upperlim, nrNoiseTraces, alignMethod );


