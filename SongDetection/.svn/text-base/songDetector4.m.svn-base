function [bDetect, tElapsed, score] = songDetector4(audio, fs, durationThreshold, ratioThreshold, minFreq, maxFreq, bDebug)
%a duration threshold of about .6 works well.  a ratioThreshold of 3 works
%well for filtered SAP files.  For unfiltered files use a lower number.

%Technique:
%1. Course Spectram
%2. Generate course binary signal. Signal is 1 if time slice of spectrogram
%has a ratio of song frequency power to non-song frequency power that
%exceeds a ratioThreshold.
%3. If great enough percentage of consequtive time points are value of 1,
%then song detected.

actInSampleRate = fs;
sig = audio;

%Parameters for part 1.  Spectrogram Parameters
windowSize = actInSampleRate/20;
windowOverlap = fix(windowSize*.5);

%Parameters for Part 2.  Frequency range in which songs typically has
%power, and power threshold.
minNdx = floor((windowSize/actInSampleRate)*minFreq + 1);
maxNdx = ceil((windowSize/actInSampleRate)*maxFreq + 1);

%Parameters for part 3
windowLength = round((actInSampleRate * .6) / (windowSize-windowOverlap)); %song average .6 seconds in length
windowAvg = repmat(1/windowLength,1,windowLength);

tic;
[b,f,t] = specgram(sig, windowSize, actInSampleRate, windowSize, windowOverlap);

powerSong = mean(abs(b(minNdx:maxNdx,:)), 1);
powerNonSong = mean(abs(b([1:minNdx-1,maxNdx+1:end],:)), 1) + eps;
songRatio = powerSong./powerNonSong;
thresCross = (songRatio>ratioThreshold);
songDet = conv(thresCross,windowAvg);
tElapsed = toc;

score = max(songDet);
bDetect = score > durationThreshold;

if(bDebug)
    h(1) = subplot(4,1,1); displayAudioSpecgram(sig,actInSampleRate,0,10000);
    h(2) = subplot(4,1,2);plot(songRatio); axis tight;
    line(xlim, [ratioThreshold, ratioThreshold],'Color','red');
    h(3) = subplot(4,1,3);plot(thresCross); axis tight;
    h(4) = subplot(4,1,4);plot(songDet); axis tight;
    line(xlim, [durationThreshold, durationThreshold],'Color','red');
    ylim([0,1]);
end

 
 
 