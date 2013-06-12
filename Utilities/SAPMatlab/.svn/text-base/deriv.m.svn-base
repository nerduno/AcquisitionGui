function [m_spec_deriv , m_AM, m_FM ,m_Entropy , m_amplitude ,gravity_center, m_PitchGoodness , m_Pitch , Pitch_chose , Pitch_weight ]=deriv(TS,fs);
% Get sound features
%        Writen by Sigal Saar August 08 2005

persistent E;

%initial filter
TS=filter_sound_sam(TS);



if size(TS,2)>size(TS,1)
    TS=TS';
end
TS=TS-min(TS);
TS=TS/max(TS)*2;
TS=TS-1;
if fs==11025
    TS= interp(x,4);
elseif fs==22050
    TS= interp(x,2);
elseif fs==44100

else
  TS=interp1(1:length(TS),TS,1:fs/44100:length(TS),'cubic');
    TS=TS';
end
fs=44100;
 
[param]=Parameters;

if(isempty(E))
    E=xlsread('tapers409.xls');
end
N=length(TS);
    
TSM=runing_windows(TS',param.window, param.winstep);
S=0;
SF=0;
if floor(param.winstep)~=param.winstep
    E=[E ; [0 0]];
end
    J1=(fft(TSM(:,:).*(ones(size(TSM,1),1)*(E(:,1))'),param.pad,2));
    J1=J1(:,1:param.spectrum_range)* ( 27539);
    J2=(fft(TSM(:,:).*(ones(size(TSM,1),1)*(E(:,2))'),param.pad,2));
    J2=J2(:,1:param.spectrum_range)* ( 27539);

    %==============Power spectrum=============
    m_powSpec=real(J1).^2+real(J2).^2+imag(J1).^2+imag(J1).^2;
    m_time_deriv=-1*(real(J1).*real(J2)+imag(J1).*imag(J2));
    m_freq_deriv=((imag(J1).*real(J2)-real(J1).*imag(J2)));

m_time_deriv_max=max(m_time_deriv.^2,[],2);
m_freq_deriv_max=max(m_freq_deriv.^2,[],2);

%===

freq_winer_ampl_index=[param.min_freq_winer_ampl:param.max_freq_winer_ampl];

m_amplitude=sum(m_powSpec(:,freq_winer_ampl_index),2);

log_power=m_time_deriv(:,freq_winer_ampl_index).^2+m_freq_deriv(:,freq_winer_ampl_index).^2; 
m_SumLog=sum(log(m_powSpec(:,freq_winer_ampl_index)+eps),2);
m_LogSum=(sum(m_powSpec(:,freq_winer_ampl_index),2)); 

gravity_center=sum((ones(size(log_power,1),1)*(freq_winer_ampl_index)).*log_power,2);
gc_base=sum(log_power,2);
m_AM=sum(m_time_deriv(:,freq_winer_ampl_index),2);


gravity_center=gravity_center./max(gc_base,1)*fs/param.pad;
m_AM=m_AM./(m_amplitude+eps);
m_amplitude=log10(m_amplitude+1)*10-70; %units in Db


%===========Wiener entropy==================

m_LogSum(find(m_LogSum==0))=length(freq_winer_ampl_index); 
m_LogSum=log(m_LogSum/length(freq_winer_ampl_index)); %divide by the number of frequencies
m_Entropy=(m_SumLog/length(freq_winer_ampl_index))-m_LogSum;
m_Entropy(find(m_LogSum==0))=0; 


%============FM===================

m_FM=atan(m_time_deriv_max./(m_freq_deriv_max+eps));
%m_FM(find(m_freq_deriv_max==0))=0;

%%%%%%%%%%%%%%%%%%%%%%%%

%==========Directional Spectral derivatives=================


cFM=cos(m_FM);
sFM=sin(m_FM);

%==The image==
m_spec_deriv=m_time_deriv(:,3:255).*(sFM*ones(1,255-3+1))+m_freq_deriv(:,3:255).*(cFM*ones(1,255-3+1));
Cepstrum=(fft(m_spec_deriv./(m_powSpec(:,3:255)+eps),512,2))*( 1/2);
x=(real(Cepstrum(:,param.up_pitch:param.low_pitch))).^2+(imag(Cepstrum(:,param.up_pitch:param.low_pitch))).^2;
[m_PitchGoodness,m_Pitch]=sort(x,2);
m_PitchGoodness=m_PitchGoodness(:,end);
m_Pitch=m_Pitch(:,end);

m_Pitch(find(m_PitchGoodness<1))=1;
m_PitchGoodness=max(m_PitchGoodness,1);

m_Pitch=m_Pitch+3;
Pitch_chose= 22050./m_Pitch ; %1./(m_Pitch/1024*fs*512);

index_m_freq=find(Pitch_chose>param.pitch_HoP & (m_PitchGoodness<param.gdn_HoP | m_Entropy>param.up_wiener));

Pitch_chose(index_m_freq)=gravity_center(index_m_freq);

Pitch_weight=Pitch_chose.*m_PitchGoodness./sum(m_PitchGoodness);

m_FM=m_FM*180/pi;

        
%save features.mat m_amplitude m_amplitude_band_1 m_amplitude_band_2 m_amplitude_band_3 m_Entropy m_Entropy_band_1 m_Entropy_band_2 m_Entropy_band_3
