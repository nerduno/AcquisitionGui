%Spike detection and extraction; extraction of noise traces
%
%detects spikes based on power of signal
%
%inputs are
%rawSignal: bandpass filtered signal
%realRawMean: running mean of unfiltered signal
%runningStd:signal to threshold
%runningThres:threshold to use on runningStd
%nrNoiseTraces: 0 (no) or >0 : get maximally x noise traces,each the same
%length as a trace of a waveform.
%alignMethod: 1=pos, 2=neg, 3=mix (order if both peaks are sig,otherwise max) -> see findpeak.m
%
%outputs are
%rawTrace: raw trace with only the parts left which were taken as spikes
%spikeWaveforms: raw waveforms
%spikeTimestamps: raw timestamp values, at peak
%noiseTraces: noise traces of specified length
%
%urut/2004
%===========================
function [rawTrace, spikeWaveforms, spikeTimestamps,  noiseTraces] = detectSpikesFromPower(rawSignal, realRawMean, runningStd, runningThres, nrNoiseTraces, alignMethod )

noiseTracesLength=64; 

spikeWaveforms=[];
spikeTimestamps=[];
noiseTraces=[];

stdRawSignal = std(rawSignal);

%find where signal crosses threshold (on power)
foundind = ( runningStd > runningThres );

%convolute to make broader on both sides
S1 =  filter(  ones(1,40), 1 , foundind)>=1;
S2 =  filter(  ones(1,40), 1 , fliplr(foundind))>=1;

inds=S1+S2;

%--dont take parts where signal was out of band 
limit=2046;
take = realRawMean > -1*limit & realRawMean < limit;

inds = inds & take;

searchInds = find( inds >= 1);

maxCovered=0;    
counterNeg=1;
counterPos=1;
totLength=length(rawSignal);

covered=[0 0];

rawTrace=zeros(1,length(rawSignal));

toInd2=0;

t1=clock;
notSig=0;
for i=1:length(searchInds)
        if maxCovered >= searchInds(i)
            continue;
        end
        
        fromInd=searchInds(i)-24;
        toInd=searchInds(i)+39;
        if fromInd<=0 || toInd>totLength || fromInd<maxCovered
            continue;
        end

        spikeSignal = rawSignal( fromInd:toInd );
        peakInd=findPeak(spikeSignal, stdRawSignal, alignMethod);
        
        %unclear spike,not detect
        if peakInd==-1
            notSig=notSig+1;
            maxCovered=toInd;
            %['not sig ' num2str(notSig)]
            continue;
        end
        
        fromInd2 = fromInd+peakInd-24;
        toInd2   = fromInd+peakInd+39;
        %already covered,to prevent repeats in any case
        if fromInd2<=0 || toInd2>length(rawSignal) || length(find(covered(:,1)==fromInd2))>0  && length(find(covered(:,2)==toInd2))>0
            continue;
        end
        
        covered(counterNeg,1:2) = [fromInd2 toInd2];
        spikeWaveforms(counterNeg,:) = rawSignal( fromInd2:toInd2 )' ;
        spikeTimestamps(counterNeg) = fromInd+peakInd;
        counterNeg=counterNeg+1;
        rawTrace(fromInd2:toInd2)=rawSignal( fromInd2:toInd2 );
        maxCovered=toInd2;
end
%-- end extracting spikes
t2=clock;

%-- extract noise traces
noiseTraces=[];
if nrNoiseTraces>0 
    searchInds = find( inds == 0);
    c=0;
    currentInd=1;
    if length(searchInds)>noiseTracesLength*nrNoiseTraces
        taken=[];
	totLengthRawSignal=length(rawSignal);
        for i=1:nrNoiseTraces
            indFrom=searchInds(currentInd);
            indTo=indFrom+noiseTracesLength-1;
           
	    if indTo > totLengthRawSignal
		break;	
	    end
            %if length(find(searchInds==indTo))==1
            %if ismember(indTo, searchInds)
                c=c+1;
                taken(c,1:2)=[indFrom indTo];
                currentInd = currentInd+10+noiseTracesLength;
            %else
            %    currentInd=currentInd+10;
            %end
            if currentInd>length(searchInds)
                break;
            end
        end    
        if size(taken,1)>0
           noiseTraces=zeros(size(taken,1), noiseTracesLength);
           for j=1:size(taken,1)
                noiseTraces(j,:)=rawSignal(taken(j,1):taken(j,2))';
           end
        end
    end
end
%---end extracting noise traces

