minFreq = 2000; %Frequency range in which song has power
maxFreq = 6000;
actInSampleRate = fs;
windowSize = actInSampleRate/20;
windowOverlap = fix(windowSize*.5);
minNdx = floor((windowSize/actInSampleRate)*minFreq + 1);
maxNdx = ceil((windowSize/actInSampleRate)*maxFreq + 1);
figure; subplot(4,1,1); displayAudioSpecgram(sig,actInSampleRate);

windowLength = round((actInSampleRate * .9) / (windowSize-windowOverlap)) %song average .9 seconds in length
windowAvg = repmat(1/windowLength,1,windowLength);

tic;
[b,f,t] = specgram(sig, windowSize, actInSampleRate, windowSize, windowOverlap);
f(minNdx);
f(maxNdx);

power = mean(abs(b(minNdx:maxNdx,:)), 1);
thresCross = (power>.15);
songDet = conv(thresCross,windowAvg);
toc

subplot(4,1,2);plot(power); axis tight;
subplot(4,1,3);plot(thresCross); axis tight;
subplot(4,1,4);plot(songDet); axis tight;


 
 
 