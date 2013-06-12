function [bDetect, tElapsed] = songDetector2(audio, fs, threshold, bDebug)
NOT YET WORKING

%Technique:
%1. Course Spectram
%2. Generate course binary signal. Signal is 1 if time slice of spectrogram
%has power in song freq range exceeding a threshold.
%3. Take specgram of course signal and look for power in frequency similar to syllable spacing in songs.

actInSampleRate = fs;
sig = audio;

%Parameters for part 1.  Spectrogram Parameters
windowSize = 1024; %actInSampleRate/50; %Made less coarse than detector 1 and made power of 2.
windowOverlap = fix(windowSize*.9); %Increased overlap

%Parameters for Part 2.  Frequency range in which songs typically has
%power, and power threshold.
minFreq = 2000; 
maxFreq = 6000;
minNdx = floor((windowSize/actInSampleRate)*minFreq + 1);
maxNdx = ceil((windowSize/actInSampleRate)*maxFreq + 1);
powerThreshold = .15;

%Parameters for part 3
timePerSamp = (windowSize - windowOverlap) / actInSampleRate; %Time per course signal sample
avgSongLength = .7; %seconds.
courseWindowSize = fix(.5 / timePerSamp);
courseWindowOverlap = fix(courseWindowSize*.5);

tic;
[b,f,t] = specgram(sig, windowSize, actInSampleRate, windowSize, windowOverlap);

power = mean(abs(b(minNdx:maxNdx,:)), 1);
thresCross = (power>powerThreshold);
specgram(thresCross, courseWindowSize, 1/timePerSamp, courseWindowSize, courseWindowOverlap);
%TO DO: Figure out where songs produce power in the spectram, compute power
%across specgram, check if it crosses threshold.
tElapsed = toc;
songDet = 0;

bDetect = max(songDet) > threshold;

if(bDebug)
    figure; subplot(4,1,1); displayAudioSpecgram(sig,actInSampleRate);
    subplot(4,1,2);plot(power); axis tight;
    subplot(4,1,3);plot(thresCross); axis tight;
    subplot(4,1,4);plot(songDet); axis tight;
    pause;
end

 
 
 