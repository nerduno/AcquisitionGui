%find statistics of sorted cells, for inclusion in paper.
%
%SNR, # spikes, ISI below, # spikes sorted of channel
%
%urut/feb05


path='/data/';

sessions={'HM_102104','HM_102204'};
sessionID=[301 302];  % patient # * 100 + session #

totalCellsAnalyzed=0;

% sessionID, channel, clusterNr, # spikes, std, SNR, peak amplitude, % ISI below 3ms, ISI below abs (# of)
stats=[];


% sessionID, channel, # spikes sorted, # spikes unsorted, length
statsChannel=[];

for z=1:length(sessions)
    basedir=[path sessions{z} '/sort/final/'];
    basedirRaw=[path sessions{z} '/raw/'];

    for channel=1:24

            fname=[basedir 'A' num2str(channel) '_sorted_new' '.mat'];
            if exist(fname)~=2
                [fname ' does not exist,skip']
                continue;
            end
        
            load(fname);
            ['processing : ' fname]

	    nrSorted=0;
	    for k=1:length(useNegative)
                  clNr = useNegative(k);
		  inds = find( assignedNegative == clNr );
                  mWaveform = mean ( newSpikesNegative(inds,:) );
		  SNR = calcSNR( mWaveform, stdEstimateOrig);

		  ISI = diff(newTimestampsNegative(inds));
		  ISI = ISI/1000; %to ms
		  
                  ISIbelowAbs  = length(find( ISI < 3.0 ));
		  ISIbelowPerc = ISIbelowAbs*100/length(ISI);

                  entry = [ sessionID(z) channel clNr length(inds) stdEstimateOrig SNR max(mWaveform) ISIbelowPerc ISIbelowAbs];
                  entryNr = size(stats,1)+1;

		  nrSorted=nrSorted+length(inds);

		  stats(entryNr,:) = entry;                  
            end

	    nrUnsorted = length( assignedNegative ) - nrSorted;

	    fnameRaw = [ basedirRaw 'A' num2str(channel) '.Ncs' ];
	    
	    entry = [ sessionID(z) channel nrSorted nrUnsorted 0 ];
            entryNr = size(statsChannel,1) + 1;
            statsChannel(entryNr,:) = entry;
    end
end

