%
%upsample spikes by factor L
%
%urut/april04
function upsampledSpikes = upsampleSpikes( allSpikesRawFiltered )

L=4;        %upsample factor
upsampledSpikes=interpft( allSpikesRawFiltered', L*size(allSpikesRawFiltered,2));
upsampledSpikes=upsampledSpikes';


