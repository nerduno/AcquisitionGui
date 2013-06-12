function Plot_Spikes_aux(handles,classes,i)
USER_DATA = get(handles.wave_clus_figure,'userdata');
par = USER_DATA{1};
spikes = USER_DATA{2};
spk_times = USER_DATA{3};
clu = USER_DATA{4};
%classes = USER_DATA{6};
%classes = classes(:)';
inspk = USER_DATA{7};
temp = USER_DATA{8};
ls = size(spikes,2);
par.to_plot_std = 1;                % # of std from mean to plot


wave_clus_aux




if i<6 
    figure(10); 
    set(gcf,'PaperOrientation','Landscape','PaperPosition',[0.25 0.25 10.5 8]) 
else
    figure(11)
    set(gcf,'PaperOrientation','Landscape','PaperPosition',[0.25 0.25 10.5 8]) 
end
if i==1 | i==6; 
    clf; 
    subplot(3,5,3)
    title([pwd par.filename],'fontsize',14)
    axis off
end
ylimit = [];
subs_spk = [6:10 6:10];
subs_isi = [11:15 11:15];
colors = ['k' 'b' 'r' 'g' 'c' 'm' 'y' 'b' 'r' 'g' 'c' 'm' 'y' 'b'];

class_aux = find(classes==i+3);

subplot(3,5,subs_spk(i)); cla;
hold on
av   = mean(spikes(class_aux,:));
avup = av + par.to_plot_std * std(spikes(class_aux,:));
avdw = av - par.to_plot_std * std(spikes(class_aux,:));
if get(handles.plot_all_button,'value') ==1
    plot(spikes(class_aux,:)','color',colors(i+4))
    plot(mean(spikes(class_aux,:)),'color','k','linewidth',2)
    plot(1:ls,avup,1:ls,avdw,'color',[.4 .4 .4],'linewidth',.5)
else
    plot(1:ls,av,'color',colors(i+4),'linewidth',2)
    plot(1:ls,avup,1:ls,avdw,'color',[.65 .65 .65],'linewidth',.5)
end
xlim([1 ls])
aux=num2str(length(class_aux));
title(['Cluster ' num2str(i+3) ':  # ' aux ],'Fontweight','bold');

subplot(3,5,subs_isi(i));cla;
times=diff(spk_times(class_aux));
eval(['[N,X]=hist(times,0:par.bin_step' num2str(i+3) ':par.nbins' num2str(i+3) ');']);
bar(X(1:end-1),N(1:end-1))
eval(['xlim([0 par.nbins' num2str(i+3) ']);']);
eval(['set(get(gca,''children''),''facecolor'',''' colors(i+4) ''',''edgecolor'',''' colors(i+4) ''',''linewidth'',0.01);']);    
title([num2str(sum(N(1:3))) ' in < 3ms'])
xlabel('ISI (ms)');
