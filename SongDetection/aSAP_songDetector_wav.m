function [bSong, scores, fileInfo] = aSAP_songDetector_wav(songDir, nonsongDir, thresDuration, thresRatio, minSongFreq, maxSongFreq)
%Michale, call the following function
%[bSong, score, fileInfo] = aSAP_songDetector_wav('c:\aarecordings\aa115\434\', .6, 10, 1000, 7000)

%First run the detection algorithm on all the files.
bDebug = false;

d = dir([songDir,'*.wav']);
d = d(1:100);
numFiles = length(d);

length(d)
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
        [bSong(nFile), timeTaken, scores(nFile)] = songDetector4(audio, fs, thresDuration, thresRatio, minSongFreq, maxSongFreq, bDebug);%All files in training set have sampleRate of 40kHz.
        if(bDebug)
            pause;
        end
    end
end
fileInfo = d;

%Then move seperate song and non-songs
try, rmdir([songDir,'songFolderTest'], 's'); end
try, rmdir([songDir,'nonsongFolderTest'], 's'); end
mkdir([songDir,'songFolderTest']);
mkdir([songDir,'nonsongFolderTest']);
for(nFile = 1:length(d))
    currfilename = [songDir,d(nFile).name];
    if(bSong(nFile))
        copyfilename = [songDir,'songFolderTest',filesep, d(nFile).name];
    else
        copyfilename = [songDir,'nonsongFolderTest',filesep, d(nFile).name];        
    end
    copyfile(currfilename, copyfilename);
end

