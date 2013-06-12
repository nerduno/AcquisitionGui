function [missFiles, falseAlarmFiles, songScores, nosongScores] = testDetectorOnTrainingSet(bDebug)

hasSongDir = 'C:\Matlab\Aaron\Code\SongDetectTrainingSet\HasSong\';
noSongDir = 'C:\Matlab\Aaron\Code\SongDetectTrainingSet\NoSong\';

duraThres =.6;
ratioThres = 10;
[numWithSongsCorrect, nSongTrain, meanTime, maxTime, missFiles, songScores] = testOnDirectory(hasSongDir, duraThres, ratioThres, 1, bDebug);
[numWithOutSongsInCorrect, nNoSongTrain, meanTime, maxTime, falseAlarmFiles, nosongScores] = testOnDirectory(noSongDir, duraThres, ratioThres, 0, bDebug);

missedFrac = 1 - (numWithSongsCorrect/ nSongTrain)
falseAlarmFrac = numWithOutSongsInCorrect /  nNoSongTrain

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

function [numWithSong, numFiles, meanTime, maxTime, failedFiles, scores] = testOnDirectory(songDir, duraThres, ratioThres, bSongExpected, bDebug)
d = dir([songDir,'*.wav']);
numFiles = length(d);

numWithSong = 0;
maxTime = 0;
meanTime = 0;
numFailed = 0;
failedFiles = {};
for(nFile = 1:length(d))
    nFile
    filename = [songDir,d(nFile).name];
    [path,name,ext] = fileparts(filename);
    if(strcmp(ext,'.wav') | strcmp(ext,'.dat'))
        if(strcmp(ext,'.dat')) 
            [temp, audio] = daq_readDatafile(filename);
            fs = 40000;
        elseif(strcmp(ext,'.wav'))
            [audio, fs] = wavread(filename);
        end
        [bSong, timeTaken, score] = songDetector4(audio, fs, duraThres, ratioThres, bDebug);%All files in training set have sampleRate of 40kHz.
        scores(nFile) = score;
        if(bSong)
            numWithSong = numWithSong + 1;
        end
        if(bSong~=bSongExpected)
            numFailed = numFailed + 1;
            failedFiles{numFailed} = filename;           
            %[bSong, timeTaken] = songDetector4(audio, fs, duraThres, ratioThres, true);
            %pause;
        end
        maxTime = max(timeTaken, maxTime);
        meanTime = meanTime + timeTaken;
    end
end
meanTime = meanTime / numFiles;

