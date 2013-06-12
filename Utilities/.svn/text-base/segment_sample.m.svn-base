rootdir = 'c:\stetner\data\';
birdName = '1772'; 
experName = '2010-08-07';
experNames = {experName};

%%  Segment and compute features for an experiment.
%Parameters
triggerSyllThreshold = -11%-2;
edgeSyllThreshold = -14%-6;
filenum = {[]};
bDebug = false;

expers = {};
expers{1} = loadExper(birdName,experName,rootdir);
expers{1}.dir = [rootdir birdName filesep experName filesep];
annotationName = [rootdir,filesep,birdName,filesep,birdName,'_annotation_',experName,'.mat'];

%segment
annotNames = caf_ProcessExperAudio(annotationName, expers, filenum, ...
    'triggerAbs', triggerSyllThreshold, 'thresholdAbs', edgeSyllThreshold, 'maxFilesPerAnnotation', 300,'bDebug',bDebug);
if bDebug
    return
end
%compute features
for(nAnnot = 1:length(annotNames))
    caf_ProcessAnnotation(annotNames{nAnnot}, [], 'all', [], ['getinfo_',birdName], 'bOnlyLabled', false, 'whichAnalyses', [1,3,5]);
end
