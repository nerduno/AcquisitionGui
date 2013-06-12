%
%
%apply bandpass filter 300...3000hz
%
function filteredSignal = filterSignal( Hd, rawSignal )

filteredSignal = filtfilt(Hd{1}, Hd{2}, rawSignal);


