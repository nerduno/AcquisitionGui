function Hd = bandPassForSong(Fs)
%BANDPASSFORSONG Returns a discrete-time filter object.

%
% M-File generated by MATLAB(R) 7.1 and the Signal Processing Toolbox 6.4.
%
% Generated on: 01-Dec-2006 18:32:19
%

% Equiripple Bandpass filter designed using the FIRPM function.

% All frequency values are in Hz.
%Fs = 40000;  % Sampling Frequency

Fstop1 = 500;             % First Stopband Frequency
Fpass1 = 860;             % First Passband Frequency
Fpass2 = 7000;            % Second Passband Frequency
Fstop2 = 7500;            % Second Stopband Frequency
Dstop1 = 0.001;           % First Stopband Attenuation
Dpass  = 0.057501127785;  % Passband Ripple
Dstop2 = 0.001;           % Second Stopband Attenuation
dens   = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fstop1 Fpass1 Fpass2 Fstop2]/(Fs/2), [0 1 ...
                          0], [Dstop1 Dpass Dstop2]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);


% [EOF]