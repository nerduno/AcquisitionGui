function [param]=Parameters(param,do,location)

%     Written by Sigal Saar 10.25.05
%==============================================================

    if nargin==0
        load('parameters.mat');
    
    elseif ~isempty(do) & location(1)~=0 
        if do(1:4)=='init' | do(1:4)=='Init'

            param.fs=44100;
            param.cutoff=10*758400000;
            param.pad=1024;%index
            param.window=409;%index
            param.winstep=44;%index
            param.cutoff_value=5.5;
            param.spectrum_range=256;%index %???
            param.min_freq_winer_ampl=20;%index 100
            param.max_freq_winer_ampl=200;%index
            param.up_pitch=3;% index 7350hz??
            param.low_pitch=55;%index 400hz??
            param.pitch_HoP=1800;%hz
            param.gdn_HoP=100;
            param.up_wiener=-2;
            param.pitch_averaging=1;%adjust pitch by its goodness
            param.x_length=750;
            param.y_length=250;
            param.initial_axes='on';
            param.NW=0;
            param.k=0;

            save parameters param;

       else
            save parameters param;
        end
    else
        display('Action canceled');
    end