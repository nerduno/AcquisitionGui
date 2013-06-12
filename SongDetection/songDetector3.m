function [bDetect, tElapsed] = songDetector3(audio, fs, threshold, bDebug)
NOT YET WORKING!!!

%Technique:
%1. Course Spectram
%2. Generate course binary signal. Signal is 1 if time slice of spectrogram
%has power in song freq range exceeding a threshold.
%3. Conv this course signal with sin wave or square wave with freq similar to syllable
%spacing.

actInSampleRate = fs;
sig = audio;

%Parameters for part 1.  Spectrogram Parameters
windowSize = actInSampleRate/20;
windowOverlap = fix(windowSize*.5);

%Parameters for Part 2.  Frequency range in which songs typically has
%power, and power threshold.
minFreq = 2000; 
maxFreq = 6000;
minNdx = floor((windowSize/actInSampleRate)*minFreq + 1);
maxNdx = ceil((windowSize/actInSampleRate)*maxFreq + 1);
powerThreshold = .15;

%Parameters for part 3
windowLength = round((actInSampleRate * .5) / (windowSize-windowOverlap)); %song average .5 seconds in length
windowAvg = repmat(1/windowLength,1,windowLength);

tic;
[b,f,t] = specgram(sig, windowSize, actInSampleRate, windowSize, windowOverlap);

power = mean(abs(b(minNdx:maxNdx,:)), 1);
thresCross = (power>powerThreshold);
songDet = conv(thresCross,windowAvg);
tElapsed = toc;

bDetect = max(songDet) > threshold;

if(bDebug)
    figure; subplot(4,1,1); displayAudioSpecgram(sig,actInSampleRate);
    subplot(4,1,2);plot(power); axis tight;
    subplot(4,1,3);plot(thresCross); axis tight;
    subplot(4,1,4);plot(songDet); axis tight;
end

 
 
 