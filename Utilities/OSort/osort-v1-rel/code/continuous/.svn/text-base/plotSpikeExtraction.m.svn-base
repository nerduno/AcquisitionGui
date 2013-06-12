%
%plots various steps of the spike extraction process.
%
%from top to bottom:
%raw signal
%filtered signal
%local energy with threshold
%spikes extracted
%empty
%
%urut/april04
function plotSpikeExtraction(label,rawSignal, rawMean, filteredSignal, rawTraceSpikes, runStd2, upperlim)

%ID='P3S1B6_block17';
%save('c:\temp\signal.mat','filteredSignal','rawSignal','runStd2','ID','upperlim');

plotFrom=25000*1;
plotTo=25000*5;

%only to generate figure
%plotFrom=2e5;
%plotTo=2e4;

subplot(5,1,1)
plot ( plotFrom:plotTo, rawSignal(plotFrom:plotTo) );
%hold on
%plot ( plotFrom:plotTo, rawMean(plotFrom:plotTo),'r' );
%hold off
title(['Raw signal ' label]);
set(gca,'XTickLabel',{})
%set(gca,'YTickLabel',{})


minVal=min(rawSignal(plotFrom:plotTo))*0.9;
maxVal=max(rawSignal(plotFrom:plotTo))*1.1;

ylim([minVal maxVal]);




subplot(5,1,2)
plot ( plotFrom:plotTo, filteredSignal(plotFrom:plotTo) )
%title('bandpass filtered');
set(gca,'XTickLabel',{})
%set(gca,'YTickLabel',{})

%--> compare to Rodrigo method of thresholding
thresRaw =  4 * median(abs(filteredSignal(plotFrom:plotTo))/0.6745);
thresRaw

length(find ( filteredSignal(plotFrom:plotTo) > 2*thresRaw ))

h=line([plotFrom plotTo],[thresRaw thresRaw]);
set(h,'color','r');
set(h,'linewidth',2);

h=line([plotFrom plotTo],[-thresRaw -thresRaw]);
set(h,'color','r');
set(h,'linewidth',2);

h=line([plotFrom plotTo],[thresRaw*2 thresRaw*2]);
set(h,'color','m');
set(h,'linewidth',2);

minVal=min(filteredSignal(plotFrom:plotTo))*0.9;
maxVal=max(filteredSignal(plotFrom:plotTo))*1.1;

ylim([minVal maxVal]);

% 
% subplot(5,1,3)
% plot ( plotFrom:plotTo, absFilteredSignal(plotFrom:plotTo) )
% hold on
% plot ( plotFrom:plotTo, absFilteredSignalMean(plotFrom:plotTo),'r' )
% hold off
% m=mean(absFilteredSignal(plotFrom:plotTo));
% s=std(absFilteredSignalMean);
% 
% line([plotFrom plotTo],[m m],'color','g');
% line([plotFrom plotTo],[m-s m-s],'color','m');
% line([plotFrom plotTo],[m+s m+s],'color','m');
% 
% title('abs');
% set(gca,'XTickLabel',{})

%subplot(5,1,3)
%plot( plotFrom:plotTo, runStd2(plotFrom:plotTo ),'b' )
%hold on
%line([plotFrom plotTo], [upperlimFixed upperlimFixed],'color','r' );
%hold off
%title('power of signal, fixed threshold');
%set(gca,'XTickLabel',{})

subplot(5,1,3)
plot( plotFrom:plotTo, runStd2(plotFrom:plotTo ),'b' )
hold on
plot( plotFrom:plotTo, upperlim(plotFrom:plotTo),'-r','linewidth',2 );
hold off
%title('power of signal, adaptive threshold');
set(gca,'XTickLabel',{})
set(gca,'YTickLabel',{})

% subplot(5,1,4)
% plot(plotFrom:plotTo, rawTraceSpikes(plotFrom:plotTo) )
% set(gca,'YTickLabel',{})

subplot(5,1,4)
plot(plotFrom:plotTo, rawTraceSpikes(plotFrom:plotTo),'b')
ylabel('pos');

%subplot(5,1,5)
%plot(plotFrom:plotTo, negativeRaw(plotFrom:plotTo),'r' )
%ylabel('neg');
%legend('positive','negative');


xlabel('Time [0.04ms/step]','FontSize',12);

%----------only for figure in paper
for i=1:5
subplot(5,1,i)
xlim([plotFrom plotTo]);
end
