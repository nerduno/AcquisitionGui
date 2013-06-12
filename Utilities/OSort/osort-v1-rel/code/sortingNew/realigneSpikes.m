%realign spikes at max (pos 95)
%
%alignMethod: 1: positive (peak is max)
%      2: negative (peak is min)
%      3: negative and do not check for too much shift
%
%urut/2004
function [newSpikes,newTimestamps] = realigneSpikes(allSpikes, allTimestamps, alignMethod, stdEstimate)

newSpikes=allSpikes;


excludeCounter=0;
excludeInds=[];

shouldMax=95;
if size(allSpikes,2)==64
    shouldMax=20;
end

    
diff=0;

for i=1:size(allSpikes,1)
    currentSpike=allSpikes(i,:);

    maxPos=0;
    %if type==1
    %    maxPos = find( currentSpike == max(currentSpike) );
    %else
        maxPos = findPeak( currentSpike, stdEstimate, alignMethod );
        
        %maximum = max ( currentSpike );
        %minimum = min ( currentSpike );
        
        %if find(currentSpike==maximum) < find(currentSpike==minimum)
        %   maxPos = find( currentSpike == maximum ); 
        %else
        %    maxPos = find( currentSpike == minimum );     
        %end        
    %end

    changed=false;
        
    if maxPos==-1
        maxPos=95;    
    end
    
    if maxPos>shouldMax
       diff = maxPos-shouldMax;
       currentSpike = [currentSpike(diff:maxPos) currentSpike(maxPos+1:end) currentSpike(end)*ones(1,diff-1)];
       changed=true;    
   end

   if maxPos<shouldMax
       diff = shouldMax-maxPos;
       currentSpike = [currentSpike(1)*ones(1,diff-1) currentSpike(1:maxPos) currentSpike(maxPos:end-diff)];   
       changed=true;    
   end
   
   if changed && diff<shouldMax/2
       newSpikes(i,:) = currentSpike;
   end
   
   %spikes that need to be shifted to much are excluded (problem in
   %extraction)
   %if changed && diff>90 && type<3
   %   excludeCounter=excludeCounter+1;
   %   excludeInds(excludeCounter)=i;
   %end
end


indsToKeep = setdiff(1:size(allSpikes,1),excludeInds);
newSpikes=newSpikes(indsToKeep,:);

if length(allTimestamps)>0
    newTimestamps=allTimestamps(indsToKeep);
else
    newTimestamps=[];
end
