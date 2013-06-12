[data1, info1] = daq_readDatafile('C:\Documents and Settings\andalman\Desktop\Piezo Microphone Data LL20090417_d000006_chan0.dat', true, []);
[data2, info2] = daq_readDatafile('C:\Documents and Settings\andalman\Desktop\Piezo Microphone Data LL20090417_d000006_chan1.dat', true, []);

[data3, info3] = daq_readDatafile('C:\Documents and Settings\andalman\Desktop\Piezo Microphone Data LL052609_d000319_chan0.dat', true, []);
[data4, info4] = daq_readDatafile('C:\Documents and Settings\andalman\Desktop\Piezo Microphone Data LL052609_d000319_chan2.dat', true, []);
[data5, info5] = daq_readDatafile('C:\Documents and Settings\andalman\Desktop\Piezo Microphone Data LL052609_d000319_chan7.dat', true, []);

%% Piezo does not record loud feedback
st = 8.41;
et = 9;

clip3 = data3(ceil(st*info1.fs):floor(et*info1.fs));
clip4 = data4(ceil(st*info1.fs):floor(et*info1.fs));
clip5 = data5(ceil(st*info1.fs):floor(et*info1.fs));

figure(2); clf;
sp(1) = subplot(9,1,1);
sp(2) = subplot(9,1,2:3);
sp(3) = subplot(9,1,4);
sp(4) = subplot(9,1,5:6);
sp(5) = subplot(9,1,7);
sp(6) = subplot(9,1,8:9);

axes(sp(1));
plot(linspace(0,(length(clip5)-1)/40000,length(clip5)), clip5);
axis tight;
set(gca, 'XTick', []);
xlabel('');

axes(sp(2));
displaySpecgramQuick(clip5,40000);
set(gca, 'XTick', []);
xlabel('');
ylabel('');

axes(sp(3));
plot(linspace(0,(length(clip4)-1)/40000,length(clip4)), clip4);
axis tight;
set(gca, 'XTick', []);
xlabel('');

axes(sp(4));
displaySpecgramQuick(clip4,40000);
set(gca, 'XTick', []);
xlabel('');
ylabel('');

axes(sp(5));
plot(linspace(0,(length(clip3)-1)/40000,length(clip3)), clip3);
axis tight;
set(gca, 'XTick', []);
xlabel('');

axes(sp(6));
displaySpecgramQuick(clip3,40000);
set(gca, 'XTick', []);
xlabel('');
ylabel('');
line([.1,.2],[1000,1000],'Color', [.2,.2,.2], 'LineWidth', 3);

%% Female call not picked up by piezo
st = 6.47;
et = 7.62;

clip1 = data1(round(st*info1.fs):round(et*info1.fs));
clip2 = data2(round(st*info1.fs):round(et*info1.fs));


figure(1); clf;
sp(1) = subplot(6,1,1);
sp(2) = subplot(6,1,2:3);
sp(3) = subplot(6,1,4);
sp(4) = subplot(6,1,5:6);

axes(sp(2));
displaySpecgramQuick(clip1,40000, [0,8101]);
set(gca, 'XTick', []);
set(gca, 'YTick', [0,8000]);
xlabel('');
ylabel('');

axes(sp(1));
plot(linspace(0,(length(clip1)-1)/40000,length(clip1)), clip1);
axis tight;
set(gca, 'XTick', []);
xlabel('');

axes(sp(4));
displaySpecgramQuick(clip2,40000, [0,8101]);
set(gca, 'XTick', []);
set(gca, 'YTick', [0,8000]);
xlabel('');
ylabel('');
line([.1,.2],[1000,1000],'Color', [.2,.2,.2], 'LineWidth', 3);

axes(sp(3));
plot(linspace(0,(length(clip2)-1)/40000,length(clip2)), clip2);
axis tight;
ylim([-.5,.5])
set(gca, 'YTick', [-0.5,0,0.5]);
set(gca, 'XTick', []);
xlabel('');

%% Power spectrum of two signals.
st = 7;
et = 11;
clip1 = data1(round(st*info1.fs):round(et*info1.fs));
clip2 = data2(round(st*info1.fs):round(et*info1.fs));


figure(1); clf;

[b, freq, time, p1] = spectrogram(clip1, 512, round(.8*512), 1024, info1.fs);
[b, freq, time, p2] = spectrogram(clip2, 512, round(.8*512), 1024, info2.fs);

plot(freq,10*log10(mean(p1,2)), 'k:'); hold on;
plot(freq,10*log10(mean(p2,2)), 'k');
xlim([0,10000]);
set(gca, 'XTick', [0,5000,10000]);

