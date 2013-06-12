%
%post-hoc whitening & upsampling of waveforms
%
%used in cases when online estimate of covariance is unstable
%
%returns:
%trans: transformed spikes
%corr:autocorrelation function of the noise
%stdWhitened: std of the whitened waveforms. if this is substantion > 0 -> electrode moved.
%
%
%urut/nov05
function [trans, transUp, corr, stdWhitened] = posthocWhiten(noiseTraces, origWaveforms, alignMethod )
noiseTraces=noiseTraces(:,2:65);


n=size(noiseTraces,1);
if n>10000
    n=10000;
end

noiseTraces=noiseTraces(1:n,:);
noiseTraces=noiseTraces';
noiseTraces=noiseTraces(:);

%estimate autocorrelation
corr=xcorr(noiseTraces,64,'biased');
corr=corr(65:end-1);

%whiten
C1=toeplitz(corr);
C1inv=inv(C1);
R1=chol(C1inv);
trans = origWaveforms * R1';

stdWhitened = mean(std(trans));

%upsample and re-align
transUp = upsampleSpikes(trans);
transUp = realigneSpikes(transUp, [], alignMethod, stdWhitened);  %3==type is negative, do not remove any if too much shift
