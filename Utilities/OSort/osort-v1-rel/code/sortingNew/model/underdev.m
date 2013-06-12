

figure(200)
ind1=100;
ind2=109;
p=256;

S1=spikeWaveformsUp(ind1,:);
S2=spikeWaveformsUp(ind2,:);
t=spikeTimestamps([ind1 ind2]);
plot( 1:p, S1, 'r', 1:p, S2, 'b')

tol=50;
nrNeuron=1;
find( spiketimes{nrNeuron} > t(1)-tol & spiketimes{nrNeuron} < t(1)+tol )
find( spiketimes{nrNeuron} > t(2)-tol & spiketimes{nrNeuron} < t(2)+tol )



%

C1=(cov(noiseTracesUp+0.02*randn(size(noiseTracesUp,1),p)));
%C1(end-5:end,:) = .01*randn(6,p);
C1inv = inv(C1);
diff1 = (S1-S2) * Cinv * (S1-S2)'

diff1O = (S1-S2) * inv(eye(p)) * (S1-S2)';

[diff1 diff1O]

diff1 = (S1-S2) * inv(C0) * (S1-S2)';

diff2 = (S1-S2) *  (S1-S2)';

alpha=0.05
v=256;
theor = chi2inv(1-alpha,v)


thres = stdEstimate^2 * p;

dist=calculateDistance( S1 , S2, ones(p,1));

[diff1 diff2 theor thres dist]



figure(201);
subplot(2,2,1)
plot( 1:64, C1(1:64),'r');
subplot(2,2,2)
plot( 1:64, C2(1:64),'r');

C0 = cov(noiseTraces);
thr = mean(C0(:));
for i=1:pp
    for j=1:pp
        if abs(C0(i,j))<thr
            C0(i,j)=0;
        end
    end
end
C0inv = inv(C0);
diff1 = (S1-S2) * inv(C0) * (S1-S2)'

figure(201);
pp=256
for i=1:64
    subplot(8,8,i)
    plot( 1:pp, Cup(1:pp,i*3),'r');
    xlim([1 pp+4]);
end

subplot(2,2,3)

figure(202)
subplot(2,1,1)
plot( 1:256, noiseTracesUp,'b')
subplot(2,1,2)
plot( 1:64, noiseTraces,'b')