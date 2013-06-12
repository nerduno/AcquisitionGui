%find all projection test values (distances and fit)
%
%
%urut/feb05

path='/data/';

sessions={'HM_102104','HM_102204'};
sessionID=[301 302];  % patient # * 100 + session #

%sessionID, channel, clusterNr1, clusterNr2, distance, fit1, fit2 mode(1: >1 neuron, 2: only 1 neuron, d + fit2 invalid)
statsProj=[];

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

	    clusters = useNegative;
	    %find all pairs
	    pairs=[];
	    c=0;
	    %significance test between all clusters
	    for i=1:length(clusters)
               for j=i+1:length(clusters)
                c=c+1;
                pairs(c,1:2)=[clusters(i) clusters(j)];
               end
            end

	    %if only 1 cluster,find fit in any case
	    if length(clusters)==1
	       pairs(1,1:2)=[clusters(1) 0];
	    end

	    for k=1:size(pairs,1)
                clNr1 = pairs(k,1);
                clNr2 = pairs(k,2);
                [channel clNr1 clNr2]
                
            	[d,residuals1,residuals2,Rsquare1, Rsquare2] = figureClusterOverlap(allSpikesCorrFree, newSpikesNegative, assignedNegative, clNr1, clNr2, '', 3, '');
                
                %if only 1 cluster,use only goodness of fit and not distance
                mode=1;
	        if size(pairs,1)==1
			mode=2;
                        d=0;
			Rsquare2=0;
	        end

                entry = [ sessionID(z) channel clNr1 clNr2 d Rsquare1 Rsquare2 mode];
                entryNr = size(statsProj,1)+1;
		statsProj(entryNr,:) = entry;                  
            end
    end
end

