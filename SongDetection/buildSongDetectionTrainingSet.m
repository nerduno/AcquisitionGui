function buildSongDetectionTrainingSet(exper,filenums)
if(exper.desiredInSampRate ~= 40000)
    error('Training Set consists only of data sampled at 40kHz');
end

for(filenum = filenums)
   audio = loadAudio(exper, filenum);
    figure(1);
    displayAudioSpecgram(audio, exper.desiredInSampRate, 0)
    nSongs = input('Are there songs (1 for yes, 0 for no)?');
    filename = getExperDatafile(exper, filenum, exper.audioCh)
    if(nSongs == 1)
        copyfile([exper.dir, filename], ['C:\MATLAB6p5\work\Aaron\SongDetectTrainingSet\HasSong\', filename]);
    else
        copyfile([exper.dir, filename], ['C:\MATLAB6p5\work\Aaron\SongDetectTrainingSet\NoSong\', filename]);
    end
end