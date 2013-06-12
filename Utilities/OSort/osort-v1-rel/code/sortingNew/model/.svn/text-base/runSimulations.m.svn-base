%main file to run the simulations (part of the paper).
%
%urut/nov05
%
%---

%-- change the following parameters
simNrs = 1;  %1,2 or 3;   1:3 for all
noiseLevelToRun = 3;   %1:4 for all
thresholdMethodToRun = 1;  %1 is approximation, 2 is exact (chi2 with prewhitening)

basepath='/home/urut/code/osort-v1-rel/data/';

%---- no parameters below this line-------
extrThresholds=[4 4 4 4;
                3 3 4 4.5;
                3 3 4 4];
                       
%-- run simulation 
%simNrs=[1 2 3];
for kk=1:length(simNrs)
    simNr=simNrs(kk);
    noiseLevels=noiseLevelToRun;
    extractionThresholds = extrThresholds(simNr,:);

    if thresholdMethodToRun==2
        thresholdMethod = 2;  %1=approx, 2=exact chi-square
        upsample=1;
        export=0;
    
        perfChi2=[];
        for i=1:length(noiseLevels)
            [perfChi2Tmp, nrAssigned, assigned] = plotGeneratedSpiketrain(basepath, simNr, noiseLevels(i), thresholdMethod, upsample, extractionThresholds(i),export );
            perfChi2{i}=perfChi2Tmp;
        end
        perfChi2Orig=perfChi2;
    end
    
    if thresholdMethodToRun==1        
        thresholdMethod=1;
        upsample=1;
        export=0;
    
        perfNorm=[];    
        for i=1:length(noiseLevels)
            [perfNormTmp, nrAssigned, assigned] = plotGeneratedSpiketrain(basepath, simNr, noiseLevels(i), thresholdMethod, upsample, extractionThresholds(i),export );
            perfNorm{i} = perfNormTmp;
        end
    end
    
    %has merges,need to remove those clusters from the calculation
    if simNr==3
        perfNormBkp = perfNorm;
        perfChi2Bkp = perfChi2;
        
        tmp=perfNorm{3};
        tmp=tmp([2 4 5],:);
        perfNorm{3}=tmp;
        
        tmp=perfNorm{4};
        tmp=tmp([2 4 5],:);
        perfNorm{4}=tmp;
        
        tmp=perfChi2{3};
        tmp=tmp([2 3 4 5],:);
        perfChi2{3}=tmp;

        tmp=perfChi2{4};
        tmp=tmp([2 3 4 5],:);
        perfChi2{4}=tmp;
    end
    
    %save(['resultsS' num2str(simNr) '.mat'],'perfAll');
    %save(['resultsSOrig' num2str(simNr) '.mat'],'perfChi2Orig');
end

