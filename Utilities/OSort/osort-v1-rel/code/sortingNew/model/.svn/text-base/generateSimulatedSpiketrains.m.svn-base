%generate simulated spiketrains of different lengths
%
%


load('allMeans.mat');

indsSimilar = find( allMeans(:,94) > 500 & allMeans(:,94)<600 );
indsSimilar=indsSimilar(1:5);
figure(20);
plot(1:256, allMeans(indsSimilar,:) );


noiseStd=0.05;
nrSamples=200*100000;  %100 sec

realWaveformsInd = indsSimilar;

%realWaveformsIndAll=[2 51 61 72 81];
%realWaveformsInd=realWaveformsIndAll([ 2 3 5]);

for i=1:4
    i
    noiseStdThis=i*noiseStd;    
    [spiketrainNoise, spiketrain, spiketrainDown, realWaveformsInd, noiseWaveformsInd,spiketimes] = generateSpiketrain(allMeans, realWaveformsInd, nrSamples, noiseStdThis);
    
    save(['simulatedMUA' num2str(i) '.mat'], '-v6');
end


