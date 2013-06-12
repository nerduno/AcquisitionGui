%
%converts from internal representation of timestamps to real timestamps
%
%urut/april04
function realTimestamps = convertTimestamps( rawTimestamps, indTimestamps )

realTimestamps=zeros(1,length(indTimestamps));

for i=1:length(indTimestamps)
    n = floor(indTimestamps(i)/512);
    
    realTimestamps(i) = rawTimestamps(n+1) + (indTimestamps(i) - n*512)*40;      %0.00004 = 25khz sampling rate. timestamps are in uV
end

