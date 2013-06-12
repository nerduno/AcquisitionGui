function stimClips = clipStimFromSignal(signal, samplingRate, stimThreshold, preStimMs, postStimMs, maxPeakWidthMs, minPeakSpacingSecs)

preStimNdx = -round((preStimMs/1000) * samplingRate);
postStimNdx = round((postStimMs/1000) * samplingRate);

[leadingEdgeNdx, fallingEdgeNdx] = detectThresholdCrossings(signal, stimThreshold, true);

%remove stim artifacts that are wider than allowed.
leadingEdgeNdx = leadingEdgeNdx(find(((leadingEdgeNdx - fallingEdgeNdx)/samplingRate)*1000 < maxPeakWidthMs));

%remove stim artifacts that are too close together.
if(length(leadingEdgeNdx) > 0)
    bGoodSpace = logical((diff(leadingEdgeNdx)/samplingRate) > minPeakSpacingSecs);
    bGoodSpace = [true;bGoodSpace] & [bGoodSpace;true];
    leadingEdgeNdx = leadingEdgeNdx(bGoodSpace);
end

if(length(leadingEdgeNdx) == 0)
    stimClips = [];
    return;
end

stimClipNdx = repmat(leadingEdgeNdx,1,postStimNdx-preStimNdx+1) + repmat([preStimNdx:postStimNdx],length(leadingEdgeNdx),1);

%Becareful because last stim in file can get cut off.
if(max(max(stimClipNdx)) > length(signal))
    stimClipNdx = stimClipNdx(1:end-1,:);
end
if(min(min(stimClipNdx)) < 1)
    stimClipNdx = stimClipNdx(2:end,:);
end
stimClips = signal(stimClipNdx);
