function varargout = wave_clus(varargin)
% WAVE_CLUS M-file for wave_clus.fig
%      WAVE_CLUS, by itself, creates a new WAVE_CLUS or raises the existing
%      singleton*.
%
%      H = WAVE_CLUS returns the handle to a new WAVE_CLUS or the handle to
%      the existing singleton*.
%
%      WAVE_CLUS('Property','Value',...) creates a new WAVE_CLUS using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to wave_clus_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      WAVE_CLUS('CALLBACK') and WAVE_CLUS('CALLBACK',hObject,...) call the
%      local function named CALLBACK in WAVE_CLUS.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wave_clus

% Last Modified by GUIDE v2.5 10-Sep-2006 17:29:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wave_clus_OpeningFcn, ...
                   'gui_OutputFcn',  @wave_clus_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before wave_clus is made visible.
function wave_clus_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for wave_clus
handles.output = hObject;
handles.datatype ='Bence';
set(handles.isi1_accept_button,'value',1);
set(handles.isi2_accept_button,'value',1);
set(handles.isi3_accept_button,'value',1);
set(handles.spike_shapes_button,'value',1);
set(handles.force_button,'value',0);
set(handles.plot_all_button,'value',1);
set(handles.plot_average_button,'value',0);
set(handles.fix1_button,'value',0);
set(handles.fix2_button,'value',0);
set(handles.fix3_button,'value',0);



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wave_clus wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = wave_clus_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



clus_colors = [0 0 1; 1 0 0; 0 0.5 0; 0 0.75 0.75; 0.75 0 0.75; 0.75 0.75 0; 0.25 0.25 0.25];
set(0,'DefaultAxesColorOrder',clus_colors)



% --- Executes on button press in load_data_button.
function load_data_button_Callback(hObject, eventdata, handles)
set(handles.isi1_accept_button,'value',1);
set(handles.isi2_accept_button,'value',1);
set(handles.isi3_accept_button,'value',1);
set(handles.isi1_reject_button,'value',0);
set(handles.isi2_reject_button,'value',0);
set(handles.isi3_reject_button,'value',0);
set(handles.isi1_nbins,'string','Auto');
set(handles.isi1_bin_step,'string','Auto');
set(handles.isi2_nbins,'string','Auto');
set(handles.isi2_bin_step,'string','Auto');
set(handles.isi3_nbins,'string','Auto');
set(handles.isi3_bin_step,'string','Auto');
set(handles.isi0_nbins,'string','Auto');
set(handles.isi0_bin_step,'string','Auto');
set(handles.force_button,'value',0);
set(handles.force_button,'string','Force');
set(handles.fix1_button,'value',0);
set(handles.fix2_button,'value',0);
set(handles.fix3_button,'value',0);

pack;

switch char(handles.datatype)

   case 'Bence'            % Aaron type data files concatenated
        pathname=handles.dirpath;
        cd(pathname);
        filename='';
        handles.par = set_parameters_ascii(filename,handles);     % Load parameters
        set(handles.min_clus_edit,'string',num2str(handles.par.min_clus));
        handles.rec_index=[];
        index_all=[];
        spikes_all=[];
        handles.flag = 1; 
        
        %Ignores the segments parameter and do one file at a time...
        indexAdj = 0;
        for j=1:handles.to_rec-handles.from_rec+1        %that's for cutting the data into pieces
            % LOAD CONTINUOUS DATA
            time_start=0;
            filename = getExperDatafile(handles.exper, j+handles.from_rec-1, handles.channel);
            set(handles.file_name,'string',['Loading:    ' handles.dirpath filename]);
            handles.filename_array{j}=filename;
            [data, time, HWChannels, startSamp, timeCreated] = loadData(handles.exper,j+handles.from_rec-1,handles.channel);
            handles.file_lengths(j)=(length(data)/handles.par.sr)*1000; %save the lenght of each file (in ms)
            handles.flag = 0;                   %flag for ploting only in the 1st loop
            
            % SPIKE DETECTION WITH AMPLITUDE THRESHOLDING
            [spikes,thr,index]  = amp_detect_wc(data',handles);       %detection with amp. thresh.
            index=index+indexAdj;
            
            index_all = [index_all index];
            spikes_all = [spikes_all; spikes];
            indexAdj = indexAdj + length(data);
        end
        index = index_all *1e3/handles.par.sr;                  %spike times in ms.
        spikes = spikes_all;
        
        USER_DATA = get(handles.wave_clus_figure,'userdata');
        USER_DATA{2}=spikes;
        USER_DATA{3}=index;
        set(handles.wave_clus_figure,'userdata',USER_DATA);

        [inspk] = wave_features_wc(spikes,handles);        % Extract spike features.

        if handles.par.match == 'y';
            naux = min(handles.par.max_spk,size(inspk,1));
            inspk_aux = inspk(1:naux,:);
        else
            inspk_aux = inspk;
        end
            
        %Interaction with SPC
        save data inspk_aux -ascii
        [clu,tree] = run_cluster(handles);
        USER_DATA = get(handles.wave_clus_figure,'userdata');
        USER_DATA{4} = clu;
        USER_DATA{5} = tree;
        USER_DATA{7} = inspk;
        set(handles.wave_clus_figure,'userdata',USER_DATA)
   
        
   case 'Aarons'            % Aaron type data files
        [filename, pathname] = uigetfile('*.dat','Select file');
        set(handles.file_name,'string',['Loading:    ' pathname filename]);
        cd(pathname);
        handles.par = set_parameters_ascii(filename,handles);     % Load parameters
        set(handles.min_clus_edit,'string',num2str(handles.par.min_clus));
        
        index_all=[];
        spikes_all=[];
        for j=1:handles.par.segments        %that's for cutting the data into pieces
            % LOAD CONTINUOUS DATA
            %load(filename); %subtracted by bence
            [HWChannels, data, time, startSamp] = daq_readDatafile([filename]);
            data=data';%added by Bence
            x=data(:)';
            tsmin = (j-1)*floor(length(data)/handles.par.segments)+1;
            tsmax = j*floor(length(data)/handles.par.segments);
            x=data(tsmin:tsmax); clear data; 
            handles.flag = 1;                   %flag for ploting only in the 1st loop
            
            % SPIKE DETECTION WITH AMPLITUDE THRESHOLDING
            [spikes,thr,index]  = amp_detect_wc(x,handles);       %detection with amp. thresh.
            index=index+tsmin-1;
            
            index_all = [index_all index];
            spikes_all = [spikes_all; spikes];
        end
        index = index_all *1e3/handles.par.sr;                  %spike times in ms.
        spikes = spikes_all;
        
        USER_DATA = get(handles.wave_clus_figure,'userdata');
        USER_DATA{2}=spikes;
        USER_DATA{3}=index;
        set(handles.wave_clus_figure,'userdata',USER_DATA);

        [inspk] = wave_features_wc(spikes,handles);        % Extract spike features.

        if handles.par.match == 'y';
            naux = min(handles.par.max_spk,size(inspk,1));
            inspk_aux = inspk(1:naux,:);
        else
            inspk_aux = inspk;
        end
            
        %Interaction with SPC
        save data inspk_aux -ascii
        [clu,tree] = run_cluster(handles);
        USER_DATA = get(handles.wave_clus_figure,'userdata');
        USER_DATA{4} = clu;
        USER_DATA{5} = tree;
        USER_DATA{7} = inspk;
        set(handles.wave_clus_figure,'userdata',USER_DATA)
    
   case 'Alexs'            % Alex's type data files
        [filename, pathname] = uigetfile('*.dat','Select file');
        set(handles.file_name,'string',['Loading:    ' pathname filename]);
        cd(pathname);
        handles.par = set_parameters_ascii(filename,handles);     % Load parameters
        set(handles.min_clus_edit,'string',num2str(handles.par.min_clus));
        
        index_all=[];
        spikes_all=[];
        for j=1:handles.par.segments        %that's for cutting the data into pieces
            % LOAD CONTINUOUS DATA
            %load(filename); %subtracted by bence
            channel=2; %determine which channel you want
            dataread = daqread(filename);
            data=dataread(:,channel);
            data=data';%added by Bence
            x=data(:)';
            tsmin = (j-1)*floor(length(data)/handles.par.segments)+1;
            tsmax = j*floor(length(data)/handles.par.segments);
            x=data(tsmin:tsmax); clear data; 
            handles.flag = 1;                   %flag for ploting only in the 1st loop
            
            % SPIKE DETECTION WITH AMPLITUDE THRESHOLDING
            [spikes,thr,index]  = amp_detect_wc(x,handles);       %detection with amp. thresh.
            index=index+tsmin-1;
            
            index_all = [index_all index];
            spikes_all = [spikes_all; spikes];
        end
        index = index_all *1e3/handles.par.sr;                  %spike times in ms.
        spikes = spikes_all;
        
        USER_DATA = get(handles.wave_clus_figure,'userdata');
        USER_DATA{2}=spikes;
        USER_DATA{3}=index;
        set(handles.wave_clus_figure,'userdata',USER_DATA);

        [inspk] = wave_features_wc(spikes,handles);        % Extract spike features.

        if handles.par.match == 'y';
            naux = min(handles.par.max_spk,size(inspk,1));
            inspk_aux = inspk(1:naux,:);
        else
            inspk_aux = inspk;
        end
            
        %Interaction with SPC
        save data inspk_aux -ascii
        [clu,tree] = run_cluster(handles);
        USER_DATA = get(handles.wave_clus_figure,'userdata');
        USER_DATA{4} = clu;
        USER_DATA{5} = tree;
        USER_DATA{7} = inspk;
        set(handles.wave_clus_figure,'userdata',USER_DATA)
        
    case 'ASCII'            % ASCII matlab files
        [filename, pathname] = uigetfile('*.mat','Select file');
        set(handles.file_name,'string',['Loading:    ' pathname filename]);
        cd(pathname);
        handles.par = set_parameters_ascii(filename,handles);     % Load parameters
        set(handles.min_clus_edit,'string',num2str(handles.par.min_clus));
        
        index_all=[];
        spikes_all=[];
        for j=1:handles.par.segments        %that's for cutting the data into pieces
            % LOAD CONTINUOUS DATA
            load(filename); %subtracted by bence
            x=data(:)';
            tsmin = (j-1)*floor(length(data)/handles.par.segments)+1;
            tsmax = j*floor(length(data)/handles.par.segments);
            x=data(tsmin:tsmax); clear data; 
            handles.flag = 1;                   %flag for ploting only in the 1st loop
            
            % SPIKE DETECTION WITH AMPLITUDE THRESHOLDING
            [spikes,thr,index]  = amp_detect_wc(x,handles);       %detection with amp. thresh.
            index=index+tsmin-1;
            
            index_all = [index_all index];
            spikes_all = [spikes_all; spikes];
        end
        index = index_all *1e3/handles.par.sr;                  %spike times in ms.
        spikes = spikes_all;
        
        USER_DATA = get(handles.wave_clus_figure,'userdata');
        USER_DATA{2}=spikes;
        USER_DATA{3}=index;
        set(handles.wave_clus_figure,'userdata',USER_DATA);

        [inspk] = wave_features_wc(spikes,handles);        % Extract spike features.

        if handles.par.match == 'y';
            naux = min(handles.par.max_spk,size(inspk,1));
            inspk_aux = inspk(1:naux,:);
        else
            inspk_aux = inspk;
        end
            
        %Interaction with SPC
        save data inspk_aux -ascii
        [clu,tree] = run_cluster(handles);
        USER_DATA = get(handles.wave_clus_figure,'userdata');
        USER_DATA{4} = clu;
        USER_DATA{5} = tree;
        USER_DATA{7} = inspk;
        set(handles.wave_clus_figure,'userdata',USER_DATA)
        
    case 'ASCII (pre-clustered)'                %ASCII matlab files
        [filename, pathname] = uigetfile('*.mat','Select file');
        set(handles.file_name,'string',['Loading:    ' pathname filename]);
        cd(pathname);
        handles.par = set_parameters_ascii(filename,handles);     % Load parameters
        set(handles.min_clus_edit,'string',num2str(handles.par.min_clus));
        
        %Load spikes and parameters
        eval(['load times_' filename ';']);
        index=cluster_class(:,2)';

        %Load clustering results
        fname = ['data_' filename(1:end-4)];           %filename for interaction with SPC
        clu=load([fname '.dg_01.lab']);
        tree=load([fname '.dg_01']); 

        USER_DATA = get(handles.wave_clus_figure,'userdata');
        USER_DATA{2} = spikes;
        USER_DATA{3} = index;
        USER_DATA{4} = clu;
        USER_DATA{5} = tree;
        if exist('inspk');
            USER_DATA{7} = inspk;
        end
        set(handles.wave_clus_figure,'userdata',USER_DATA)

        %Load continuous data (for ploting)
        load(filename);
        x=data(:)'; 
        x(60*handles.par.sr+1:end)=[];      %will plot just 60 sec.

        [spikes,thr,index] = amp_detect_wc(x,handles);     % Detection with amp. thresh.
       
        
    case 'ASCII spikes'
        [filename, pathname] = uigetfile('*.mat','Select file');
        set(handles.file_name,'string',['Loading:    ' pathname filename]);
        cd(pathname);
        handles.par = set_parameters_ascii_spikes(filename,handles);     % Load parameters
        set(handles.min_clus_edit,'string',num2str(handles.par.min_clus));
        axes(handles.cont_data); cla
        
        %Load spikes
        load(filename);
        
        [inspk] = wave_features_wc(spikes,handles);        % Extract spike features.

        if handles.par.match == 'y';
            naux = min(handles.par.max_spk,size(inspk,1));
            inspk_aux = inspk(1:naux,:);
        else
            inspk_aux = inspk;
        end
            
        %Interaction with SPC
        save data inspk_aux -ascii
        [clu,tree] = run_cluster(handles);
        USER_DATA = get(handles.wave_clus_figure,'userdata');
        USER_DATA{2} = spikes;
        USER_DATA{3} = index(:)';
        USER_DATA{4} = clu;
        USER_DATA{5} = tree;
        USER_DATA{7} = inspk;
        set(handles.wave_clus_figure,'userdata',USER_DATA)
        
        
    case 'ASCII spikes (pre-clustered)'
        [filename, pathname] = uigetfile('*.mat','Select file');
        set(handles.file_name,'string',['Loading:    ' pathname filename]);
        cd(pathname);
        handles.par = set_parameters_ascii_spikes(filename,handles);     % Load parameters
        set(handles.min_clus_edit,'string',num2str(handles.par.min_clus));
        axes(handles.cont_data); cla

        %Load spikes and parameters
        eval(['load times_' filename ';']);
        index=cluster_class(:,2)';

        %Load clustering results
        fname = ['data_' filename(1:end-4)];           %filename for interaction with SPC
        clu=load([fname '.dg_01.lab']);
        tree=load([fname '.dg_01']); 

        USER_DATA = get(handles.wave_clus_figure,'userdata');
        USER_DATA{2} = spikes;
        USER_DATA{3} = index(:)';
        USER_DATA{4} = clu;
        USER_DATA{5} = tree;
        set(handles.wave_clus_figure,'userdata',USER_DATA)
        
end    


temp=find_temp(tree,handles);                % Selects temperature.
axes(handles.temperature_plot);
switch handles.par.temp_plot
    case 'lin'
        plot([1 handles.par.num_temp],[handles.par.min_clus handles.par.min_clus],'k:',...
            1:handles.par.num_temp,tree(1:handles.par.num_temp,5:size(tree,2)),[temp temp],[1 tree(1,5)],'k:')
    case 'log'
        semilogy([1 handles.par.num_temp],[handles.par.min_clus handles.par.min_clus],'k:',...
            1:handles.par.num_temp,tree(1:handles.par.num_temp,5:size(tree,2)),[temp temp],[1 tree(1,5)],'k:')
end
xlim([0 handles.par.num_temp + 0.5])
xlabel('Temperature'); ylabel('Clusters size');
set(handles.file_name,'string',[pathname filename]);

if size(clu,2)-2 < size(spikes,1);
    classes = clu(temp,3:end)+1;
    classes = [classes(:)' zeros(1,size(spikes,1)-handles.par.max_spk)];
else
    classes = clu(temp,3:end)+1;
end

guidata(hObject, handles);
USER_DATA = get(handles.wave_clus_figure,'userdata');
USER_DATA{6} = classes(:)';
USER_DATA{8} = temp;
USER_DATA{9} = classes(:)';         % backup for non-forced classes.
set(handles.wave_clus_figure,'userdata',USER_DATA);

plot_spikes(handles);


% --- Executes on button press in change_temperature_button.
function change_temperature_button_Callback(hObject, eventdata, handles)
axes(handles.temperature_plot)
[temp aux]= ginput(1);                  %gets the mouse input
temp = round(temp);
if temp < 1; temp=1;end                 %temp should be within the limits
if temp > handles.par.num_temp; temp=handles.par.num_temp; end
min_clus = round(aux);
set(handles.min_clus_edit,'string',num2str(min_clus));

USER_DATA = get(handles.wave_clus_figure,'userdata');
par = USER_DATA{1};
par.min_clus = min_clus;
clu = USER_DATA{4};
classes = clu(temp,3:end)+1;
tree = USER_DATA{5};
USER_DATA{1} = par;
USER_DATA{6} = classes(:)';
USER_DATA{8} = temp;
USER_DATA{9} = classes(:)';         % backup for non-forced classes.
set(handles.wave_clus_figure,'userdata',USER_DATA);

switch par.temp_plot
    case 'lin'
        plot([1 handles.par.num_temp],[par.min_clus par.min_clus],'k:',...
            1:par.num_temp,tree(1:par.num_temp,5:size(tree,2)),[temp temp],[1 tree(1,5)],'k:')
    case 'log'
        semilogy([1 handles.par.num_temp],[par.min_clus par.min_clus],'k:',...
            1:par.num_temp,tree(1:par.num_temp,5:size(tree,2)),[temp temp],[1 tree(1,5)],'k:')
end
xlim([0 par.num_temp + 0.5])
xlabel('Temperature'); ylabel('Clusters size');
plot_spikes(handles);
set(handles.force_button,'value',0);
set(handles.force_button,'string','Force');
set(handles.fix1_button,'value',0);
set(handles.fix2_button,'value',0);
set(handles.fix3_button,'value',0);


% --- Change min_clus_edit     
function min_clus_edit_Callback(hObject, eventdata, handles)
USER_DATA = get(handles.wave_clus_figure,'userdata');
par = USER_DATA{1};
par.min_clus = str2num(get(hObject, 'String'));
clu = USER_DATA{4};
temp = USER_DATA{8};
classes = clu(temp,3:end)+1;
tree = USER_DATA{5};
USER_DATA{1} = par;
USER_DATA{6} = classes(:)';
USER_DATA{9} = classes(:)';         % backup for non-forced classes.
set(handles.wave_clus_figure,'userdata',USER_DATA);

axes(handles.temperature_plot)
switch par.temp_plot
    case 'lin'
        plot([1 handles.par.num_temp],[par.min_clus par.min_clus],'k:',...
            1:par.num_temp,tree(1:par.num_temp,5:size(tree,2)),[temp temp],[1 tree(1,5)],'k:')
    case 'log'
        semilogy([1 handles.par.num_temp],[par.min_clus par.min_clus],'k:',...
            1:par.num_temp,tree(1:par.num_temp,5:size(tree,2)),[temp temp],[1 tree(1,5)],'k:')
end
xlim([0 par.num_temp + 0.5])
xlabel('Temperature'); ylabel('Clusters size');
plot_spikes(handles);
set(handles.force_button,'value',0);
set(handles.force_button,'string','Force');
set(handles.fix1_button,'value',0);
set(handles.fix2_button,'value',0);
set(handles.fix3_button,'value',0);



% --- Executes on button press in save_clusters_button.
function save_clusters_button_Callback(hObject, eventdata, handles)
USER_DATA = get(handles.wave_clus_figure,'userdata');
spikes = USER_DATA{2};
par = USER_DATA{1};
classes = USER_DATA{6};
cont=0;

% Classes should be consecutive numbers
i=1;
while i<=max(classes)
    if isempty(classes(find(classes==i)))
        for k=i+1:max(classes)
            classes(find(classes==k))=k-1;
        end
    else
        i=i+1;
    end
end

%Saves clusters
if (strcmp(handles.datatype, 'Bence'))
    cluster_class_all=zeros(size(spikes,1),2);
    cluster_class_all(:,1) = classes(:);
    cluster_class_all(:,2) = USER_DATA{3}';
    time_shift=0;
    index_shift=0;
    for i=1:handles.to_rec-handles.from_rec+1
        spike_index(i)=find(cluster_class_all(:,2)<handles.file_lengths(i),1,'last');
        
        if (i>1)
            time_shift=time_shift+handles.file_lengths(i-1);%make sure the concatenated files are separated agin in time
            spike_index(i)=find(cluster_class_all(:,2)<handles.file_lengths(i)+time_shift,1,'last');
            cluster_class=cluster_class_all(spike_index(i-1)+1:spike_index(i),:);
            cluster_class(:,2)=cluster_class(:,2)-time_shift;
            
        else
            cluster_class=cluster_class_all(1:spike_index(i),:);
        end
        filename=handles.filename_array{i};
        par.filename=filename;
        outfile=['times_' filename(1:end-4)];
%         if ~isempty(USER_DATA{7})
%             inspk = USER_DATA{7};
%             save(outfile, 'cluster_class', 'par','spikes','inspk');
%         else
%             save(outfile, 'cluster_class', 'par','spikes');
%         end
        save(outfile, 'cluster_class', 'par');
    end
else
    cluster_class=zeros(size(spikes,1),2);
    cluster_class(:,1) = classes(:);
    cluster_class(:,2) = USER_DATA{3}';
    outfile=['times_' par.filename(1:end-4)];
    if ~isempty(USER_DATA{7})
        inspk = USER_DATA{7};
        save(outfile, 'cluster_class', 'par','spikes','inspk');
    else
        save(outfile, 'cluster_class', 'par','spikes');
    end
end
%Save figures

h_figs=get(0,'children');
h_fig = findobj(h_figs,'tag','wave_clus_figure');
h_fig1 = findobj(h_figs,'tag','wave_clus_aux');
h_fig2= findobj(h_figs,'tag','wave_clus_aux1');
if strcmp(outfile(7:9),'CSC')
    if ~isempty(h_fig)
        figure(h_fig); set(gcf,'papertype','usletter','paperorientation','portrait','paperunits','inches')
        set(gcf,'paperposition',[.25 .25 10.5 7.8])
        eval(['print -djpeg fig2print_ch' outfile(10:end)]);
    end
    if ~isempty(h_fig1)
        figure(h_fig1); set(gcf,'papertype','usletter','paperorientation','portrait','paperunits','inches')
        set(gcf,'paperposition',[.25 .25 10.5 7.8])
        eval(['print -djpeg fig2print_ch' outfile(10:end) 'a']);
    end
    if ~isempty(h_fig2)
        figure(h_fig2); set(gcf,'papertype','usletter','paperorientation','portrait','paperunits','inches')
        set(gcf,'paperposition',[.25 .25 10.5 7.8])
        eval(['print -djpeg fig2print_ch' outfile(10:end) 'b']);
    end
else
    if ~isempty(h_fig)
        figure(h_fig); set(gcf,'papertype','usletter','paperorientation','portrait','paperunits','inches')
        set(gcf,'paperposition',[.25 .25 10.5 7.8])
        eval(['print -djpeg fig2print_' outfile(7:end)]);
    end
    if ~isempty(h_fig1)
        figure(h_fig1); set(gcf,'papertype','usletter','paperorientation','portrait','paperunits','inches')
        set(gcf,'paperposition',[.25 .25 10.5 7.8])
        eval(['print -djpeg fig2print_' outfile(7:end) 'a']);
    end
    if ~isempty(h_fig2)
        figure(h_fig2); set(gcf,'papertype','usletter','paperorientation','portrait','paperunits','inches')
        set(gcf,'paperposition',[.25 .25 10.5 7.8])
        eval(['print -djpeg fig2print_' outfile(7:end) 'b']);
    end
end


% --- Executes on selection change in data_type_popupmenu.
function data_type_popupmenu_Callback(hObject, eventdata, handles)
aux = get(hObject, 'String');
aux1 = get(hObject, 'Value');
handles.datatype = aux(aux1);
guidata(hObject, handles);


% --- Executes on button press in set_parameters_button.
function set_parameters_button_Callback(hObject, eventdata, handles)
helpdlg('Check the set_parameters files in the subdirectory Wave_clus\Parameters_files');


%SETTING OF FORCE MEMBERSHIP
% --------------------------------------------------------------------
function force_button_Callback(hObject, eventdata, handles)
%set(gcbo,'value',1);
USER_DATA = get(handles.wave_clus_figure,'userdata');
par = USER_DATA{1};
spikes = USER_DATA{2};
classes = USER_DATA{6};
inspk = USER_DATA{7};
switch par.force_feature
    case 'spk'
        f_in  = spikes(find(classes~=0),:);
        f_out = spikes(find(classes==0),:);
    case 'wav'
        if isempty(inspk)
            [inspk] = wave_features_wc(spikes,handles);        % Extract spike features.
            USER_DATA{7} = inspk;
        end
        f_in  = inspk(find(classes~=0),:);
        f_out = inspk(find(classes==0),:);
end
class_in = classes(find(classes~=0));

if get(handles.force_button,'value') ==1
    class_out = force_membership_wc(f_in, class_in, f_out, handles);
    classes(find(classes==0)) = class_out;
    set(handles.force_button,'string','Forced');
elseif get(handles.force_button,'value') ==0
    classes = USER_DATA{9};
    set(handles.force_button,'string','Force');
end
USER_DATA{6} = classes(:)';
set(handles.wave_clus_figure,'userdata',USER_DATA)

plot_spikes(handles);

set(handles.fix1_button,'value',0);
set(handles.fix2_button,'value',0);
set(handles.fix3_button,'value',0);


% PLOT ALL PROJECTIONS BUTTON
% --------------------------------------------------------------------
function Plot_all_projections_button_Callback(hObject, eventdata, handles)
Plot_all_features(handles)
% --------------------------------------------------------------------


% fix1 button --------------------------------------------------------------------
function fix1_button_Callback(hObject, eventdata, handles)
USER_DATA = get(handles.wave_clus_figure,'userdata');
classes = USER_DATA{6};
fix_class = find(classes==1);
if get(handles.fix1_button,'value') ==1
    USER_DATA{10} = fix_class;
else
    USER_DATA{10} = [];
end
set(handles.wave_clus_figure,'userdata',USER_DATA)

% fix2 button --------------------------------------------------------------------
function fix2_button_Callback(hObject, eventdata, handles)
USER_DATA = get(handles.wave_clus_figure,'userdata');
classes = USER_DATA{6};
fix_class = find(classes==2);
if get(handles.fix2_button,'value') ==1
    USER_DATA{11} = fix_class;
else
    USER_DATA{11} = [];
end
set(handles.wave_clus_figure,'userdata',USER_DATA)

% fix3 button --------------------------------------------------------------------
function fix3_button_Callback(hObject, eventdata, handles)
USER_DATA = get(handles.wave_clus_figure,'userdata');
classes = USER_DATA{6};
fix_class = find(classes==3);
if get(handles.fix3_button,'value') ==1
    USER_DATA{12} = fix_class;
else
    USER_DATA{12} = [];
end
set(handles.wave_clus_figure,'userdata',USER_DATA)



%SETTING OF SPIKE FEATURES OR PROJECTIONS
% --------------------------------------------------------------------
function spike_shapes_button_Callback(hObject, eventdata, handles)
set(gcbo,'value',1);
set(handles.spike_features_button,'value',0);
plot_spikes(handles);
% --------------------------------------------------------------------
function spike_features_button_Callback(hObject, eventdata, handles)
set(gcbo,'value',1);
set(handles.spike_shapes_button,'value',0);
plot_spikes(handles);


%SETTING OF SPIKE PLOTS
% --------------------------------------------------------------------
function plot_all_button_Callback(hObject, eventdata, handles)
set(gcbo,'value',1);
set(handles.plot_average_button,'value',0);
plot_spikes(handles);
% --------------------------------------------------------------------
function plot_average_button_Callback(hObject, eventdata, handles)
set(gcbo,'value',1);
set(handles.plot_all_button,'value',0);
plot_spikes(handles);



%SETTING OF ISI HISTOGRAMS
% --------------------------------------------------------------------
function isi1_nbins_Callback(hObject, eventdata, handles)
USER_DATA = get(handles.wave_clus_figure,'userdata');
par = USER_DATA{1};
par.nbins1 = str2num(get(hObject, 'String'));
USER_DATA{1} = par;
set(handles.wave_clus_figure,'userdata',USER_DATA);
plot_spikes(handles)
% --------------------------------------------------------------------
function isi1_bin_step_Callback(hObject, eventdata, handles)
USER_DATA = get(handles.wave_clus_figure,'userdata');
par = USER_DATA{1};
par.bin_step1 = str2num(get(hObject, 'String'));
USER_DATA{1} = par;
set(handles.wave_clus_figure,'userdata',USER_DATA);
plot_spikes(handles)
% --------------------------------------------------------------------
function isi2_nbins_Callback(hObject, eventdata, handles)
USER_DATA = get(handles.wave_clus_figure,'userdata');
par = USER_DATA{1};
par.nbins2 = str2num(get(hObject, 'String'));
USER_DATA{1} = par;
set(handles.wave_clus_figure,'userdata',USER_DATA);
plot_spikes(handles)
% --------------------------------------------------------------------
function isi2_bin_step_Callback(hObject, eventdata, handles)
USER_DATA = get(handles.wave_clus_figure,'userdata');
par = USER_DATA{1};
par.bin_step2 = str2num(get(hObject, 'String'));
USER_DATA{1} = par;
set(handles.wave_clus_figure,'userdata',USER_DATA);
plot_spikes(handles)
% --------------------------------------------------------------------
function isi3_nbins_Callback(hObject, eventdata, handles)
USER_DATA = get(handles.wave_clus_figure,'userdata');
par = USER_DATA{1};
par.nbins3 = str2num(get(hObject, 'String'));
USER_DATA{1} = par;
set(handles.wave_clus_figure,'userdata',USER_DATA);
plot_spikes(handles)
% --------------------------------------------------------------------
function isi3_bin_step_Callback(hObject, eventdata, handles)
USER_DATA = get(handles.wave_clus_figure,'userdata');
par = USER_DATA{1};
par.bin_step3 = str2num(get(hObject, 'String'));
USER_DATA{1} = par;
set(handles.wave_clus_figure,'userdata',USER_DATA);
plot_spikes(handles)
% --------------------------------------------------------------------
function isi0_nbins_Callback(hObject, eventdata, handles)
USER_DATA = get(handles.wave_clus_figure,'userdata');
par = USER_DATA{1};
par.nbins0 = str2num(get(hObject, 'String'));
USER_DATA{1} = par;
set(handles.wave_clus_figure,'userdata',USER_DATA);
plot_spikes(handles)
% --------------------------------------------------------------------
function isi0_bin_step_Callback(hObject, eventdata, handles)
USER_DATA = get(handles.wave_clus_figure,'userdata');
par = USER_DATA{1};
par.bin_step0 = str2num(get(hObject, 'String'));
USER_DATA{1} = par;
set(handles.wave_clus_figure,'userdata',USER_DATA);
plot_spikes(handles)



%SETTING OF ISI BUTTONS

% --------------------------------------------------------------------
function isi1_accept_button_Callback(hObject, eventdata, handles)
set(gcbo,'value',1);
set(handles.isi1_reject_button,'value',0);

% --------------------------------------------------------------------
function isi1_reject_button_Callback(hObject, eventdata, handles)
set(gcbo,'value',1);
set(handles.isi1_accept_button,'value',0);
USER_DATA = get(handles.wave_clus_figure,'userdata');
classes = USER_DATA{6};
classes(find(classes==1))=0;
USER_DATA{6} = classes;
USER_DATA{9} = classes;
set(handles.wave_clus_figure,'userdata',USER_DATA);

plot_spikes(handles)

set(gcbo,'value',0);
set(handles.isi1_accept_button,'value',1);

% --------------------------------------------------------------------
function isi2_accept_button_Callback(hObject, eventdata, handles)
set(gcbo,'value',1);
set(handles.isi2_reject_button,'value',0);

% --------------------------------------------------------------------
function isi2_reject_button_Callback(hObject, eventdata, handles)
set(gcbo,'value',1);
set(handles.isi2_accept_button,'value',0);
USER_DATA = get(handles.wave_clus_figure,'userdata');
classes = USER_DATA{6};
classes(find(classes==2))=0;
USER_DATA{6} = classes;
USER_DATA{9} = classes;
set(handles.wave_clus_figure,'userdata',USER_DATA);

plot_spikes(handles)

set(gcbo,'value',0);
set(handles.isi2_accept_button,'value',1);

% --------------------------------------------------------------------
function isi3_accept_button_Callback(hObject, eventdata, handles)
set(gcbo,'value',1);
set(handles.isi3_reject_button,'value',0);

% --------------------------------------------------------------------
function isi3_reject_button_Callback(hObject, eventdata, handles)
set(gcbo,'value',1);
set(handles.isi3_accept_button,'value',0);
USER_DATA = get(handles.wave_clus_figure,'userdata');
classes = USER_DATA{6};
classes(find(classes==3))=0;
USER_DATA{6} = classes;
USER_DATA{9} = classes;
set(handles.wave_clus_figure,'userdata',USER_DATA);

plot_spikes(handles)

set(gcbo,'value',0);
set(handles.isi3_accept_button,'value',1);


% --- Executes during object creation, after setting all properties.
function isi1_nbins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to isi1_nbins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function isi1_bin_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to isi1_bin_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function isi2_nbins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to isi2_nbins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function isi2_bin_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to isi2_bin_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function isi3_nbins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to isi3_nbins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function isi3_bin_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to isi3_bin_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function isi0_nbins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to isi0_nbins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function isi0_bin_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to isi0_bin_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function min_clus_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_clus_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in exper.
function exper_Callback(hObject, eventdata, handles)
% hObject    handle to exper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.filename,handles.dirpath]=uigetfile('*.*');
load([handles.dirpath handles.filename]);
cd (handles.dirpath);
exper.dir=handles.dirpath;
handles.ch=exper.sigCh;
handles.exper=exper;
handles.birdname=exper.birdname;
guidata(hObject, handles);


% --- Executes on selection change in channel.
function channel_Callback(hObject, eventdata, handles)
% hObject    handle to channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns channel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channel
handles.channel=get(hObject,'Value');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function from_Callback(hObject, eventdata, handles)
% hObject    handle to from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of from as text
%        str2double(get(hObject,'String')) returns contents of from as a double
handles.from_rec=str2double(get(hObject,'String'));
set(handles.from,'String',num2str(handles.from_rec));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function to_Callback(hObject, eventdata, handles)
% hObject    handle to to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of to as text
%        str2double(get(hObject,'String')) returns contents of to as a double
handles.to_rec=str2double(get(hObject,'String'));
set(handles.to,'String',num2str(handles.to_rec));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


