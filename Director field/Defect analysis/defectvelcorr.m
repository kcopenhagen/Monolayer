function defectvelcorr(datapath)
%%
addpath('../Director field');

folders = dir(datapath);
dF = [folders.isdir];
folders = folders(dF);
del = [];
for f = 1:numel(folders)
    if folders(f).name(1) == '.'
        del = [del; f];
    end
end
folders(del) = [];

eds = -pi+pi/240:pi/120:pi;
taus = 1:150;
sp = 1;
mf = 1/sp*ones(sp,1);

pdang = zeros(numel(taus),numel(eds)-1);
ndang = zeros(numel(taus),numel(eds)-1);
psqtot = zeros(numel(taus),1);
psqcount = zeros(numel(taus),1);
nsqtot = zeros(numel(taus),1);
nsqcount = zeros(numel(taus),1);
nthetas = cell(numel(taus),1);
pthetas = cell(numel(taus),1);

pdot = zeros(numel(taus),1);
pdxttot = zeros(numel(taus),1);
pdxtptautot = zeros(numel(taus),1);
pdyttot = zeros(numel(taus),1);
pdytptautot = zeros(numel(taus),1);

ndot = zeros(numel(taus),1);
ndxttot = zeros(numel(taus),1);
ndxtptautot = zeros(numel(taus),1);
ndyttot = zeros(numel(taus),1);
ndytptautot = zeros(numel(taus),1);

for f = 1:numel(folders)

    fpath = [folders(f).folder '/' folders(f).name '/'];
    XYcal = getXYcal(fpath);

    load([fpath 'adefs.mat'],'adefs');

    ids = unique([adefs.id]);

    for ij = 1:numel(ids)
        id = ids(ij);
        x = [adefs([adefs.id]==id).x];
        y = [adefs([adefs.id]==id).y];
        tt = [adefs([adefs.id]==id).tt]/60;
        q = [adefs([adefs.id]==id).q];

        x2 = x(2:end);
        x(end) = [];
        y2 = y(2:end);
        y(end) = [];
        t2 = tt(2:end);
        tt(end) = [];

%         vx = XYcal*(x2-x)./(t2-tt);
%         vy = XYcal*(y2-y)./(t2-tt);

        d = [adefs([adefs.id]==id).d];
        dx = d(1:2:end-3);
        dy = d(2:2:end-2);
        dx2 = dx*cos(2*pi/3)-dy*sin(2*pi/3);
        dy2 = dx*sin(2*pi/3)+dy*cos(2*pi/3);
        dx3 = dx*cos(4*pi/3)-dy*sin(4*pi/3);
        dy3 = dx*sin(4*pi/3)+dy*cos(4*pi/3);
        dd = sqrt(dx.^2+dy.^2);

        if q(1) > 0
            for tau = taus

                for t = 1:numel(dx)-tau
                    theta = sign(dx(t)*dy(t+tau)-dy(t)*dx(t+tau))...
                        *acos((dx(t)*dx(t+tau)+dy(t)*dy(t+tau))/(dd(t)*dd(t+tau)));
                    pthetas{tau} = [pthetas{tau}; theta];
                    bintheta = histcounts(theta,eds);
                    
                    psqtot(tau) = psqtot(tau) + theta^2;
                    psqcount(tau) = psqcount(tau) + 1;
                    pdang(tau,:) = pdang(tau,:) + bintheta;
                    
                    pdot(tau) = pdot(tau)+dx(t)*dx(t+tau)+dy(t)*dy(t+tau);
                    pdxttot(tau) = pdxttot(tau)+dx(t);
                    pdxtptautot(tau) = pdxtptautot(tau)+dx(t+tau);
                    pdyttot(tau) = pdyttot(tau)+dy(t);
                    pdytptautot(tau) = pdytptautot(tau)+dy(t+tau);
                    
                end
            end
        elseif q(1) < 0
            for tau = taus
                for t = 1:numel(dx)-tau
                    dxt = dx;
                    dyt = dy;
                    dxtau = dx;
                    dytau = dy;
                    theta = sign(dxt(t)*dytau(t+tau)-dyt(t)*dxtau(t+tau))...
                        *acos((dxt(t)*dxtau(t+tau)+dyt(t)*dytau(t+tau))/(dd(t)*dd(t+tau)));
                    if theta > pi/3 || theta < -pi/3
                        dxtau = dx2;
                        dytau = dy2;
                        theta = sign(dxt(t)*dytau(t+tau)-dyt(t)*dxtau(t+tau))...
                            *acos((dxt(t)*dxtau(t+tau)+dyt(t)*dytau(t+tau))/(dd(t)*dd(t+tau)));
                    end
                    if theta > pi/3 || theta < -pi/3
                        dxtau = dx3;
                        dytau = dy3;
                        theta = sign(dxt(t)*dytau(t+tau)-dyt(t)*dxtau(t+tau))...
                            *acos((dxt(t)*dxtau(t+tau)+dyt(t)*dytau(t+tau))/(dd(t)*dd(t+tau)));
                    end
                    
                    nthetas{tau} = [nthetas{tau}; theta];
                    bintheta = histcounts(theta,eds);
                    nsqtot(tau) = nsqtot(tau) + theta^2;
                    nsqcount(tau) = nsqcount(tau) + 1;
                    ndang(tau,:) = ndang(tau,:) + bintheta;
                    
                    angles = atan2(dy,dx);
                    %angles = mod(3*angles,2*pi);
                    dxt = cos(angles);
                    dyt = sin(angles);
                    
                    %ndot(tau) = ndot(tau)+ dxt(t)*dxt(t+tau)+dyt(t)*dyt(t+tau);
                    ndxttot(tau) = ndxttot(tau) + dxt(t);
                    ndyttot(tau) = ndyttot(tau) + dyt(t);
                    
                    ndxtptautot(tau) = ndxtptautot(tau) + dxt(t+tau);
                    ndytptautot(tau) = ndytptautot(tau) + dyt(t+tau);
                    
                    ndot1 = ndot(tau)+dx(t)*dx(t+tau)+dy(t)*dy(t+tau);
                    ndot2 = ndot(tau)+dx(t)*dx2(t+tau)+dy(t)*dy2(t+tau);
                    ndot3 = ndot(tau)+dx(t)+dy3(t+tau)+dy(t)*dy3(t+tau);
                    
                    if ndot1>ndot2 && ndot1>ndot3
                        ndot(tau) = ndot1;
                    elseif ndot2>ndot1 && ndot2>ndot3
                        ndot(tau) = ndot2;
                    else
                        ndot(tau) = ndot3;
                    end
                    
%                     ndxtest1 = ndxttot(tau) + dx(t);
%                     ndytest1 = ndyttot(tau) + dy(t);
%                     mag1 = sqrt(ndxtest1^2+ndytest1^2);
%                     ndxtest2 = ndxttot(tau) + dx2(t);
%                     ndytest2 = ndyttot(tau) + dy2(t);
%                     mag2 = sqrt(ndxtest2^2+ndytest2^2);
%                     ndxtest3 = ndxttot(tau) + dx3(t);
%                     ndytest3 = ndyttot(tau) + dy3(t);
%                     mag3 = sqrt(ndxtest3^2+ndytest3^2);
%                     if mag1>mag2 && mag1>mag3
%                         ndxttot(tau) = ndxtest1;
%                         ndyttot(tau) = ndytest1;
%                     elseif mag2>mag1 && mag2>mag3
%                         ndxttot(tau) = ndxtest2;
%                         ndyttot(tau) = ndytest2;
%                     else
%                         ndxttot(tau) = ndxtest3;
%                         ndyttot(tau) = ndytest3;
%                     end
%                     
%                     ndxtest1 = ndxttot(tau) + dx(t+tau);
%                     ndytest1 = ndyttot(tau) + dy(t+tau);
%                     mag1 = sqrt(ndxtest1^2+ndytest1^2);
%                     ndxtest2 = ndxttot(tau) + dx2(t+tau);
%                     ndytest2 = ndyttot(tau) + dy2(t+tau);
%                     mag2 = sqrt(ndxtest2^2+ndytest2^2);
%                     ndxtest3 = ndxttot(tau) + dx3(t+tau);
%                     ndytest3 = ndyttot(tau) + dy3(t+tau);
%                     mag3 = sqrt(ndxtest3^2+ndytest3^2);
%                     if mag1>mag2 && mag1>mag3
%                         ndxtptautot(tau) = ndxtest1;
%                         ndyttot(tau) = ndytest1;
%                     elseif mag2>mag1 && mag2>mag3
%                         ndxtptautot(tau) = ndxtest2;
%                         ndytptautot(tau) = ndytest2;
%                     else
%                         ndxtptautot(tau) = ndxtest3;
%                         ndytptautot(tau) = ndytest3;
%                     end
%                     
                    
                end
            end
        end
    end
end

for i = 1:numel(pdang(:,1))
    pdang(i,:) = pdang(i,:)/sum(pdang(i,:));
    ndang(i,:) = ndang(i,:)/sum(ndang(i,:));
end

%%
figure
pys = [];
xs = [];
pyerrs = [];
nys = [];
nyerrs = [];
for t = 1:numel(taus)
    xs = [xs; taus(t)];
    pys = [pys; mean(pthetas{t}.^2)];
    pyerrs = [pyerrs; var(pthetas{t}.^2)];%/sqrt(numel(pthetas{t}))];
    nys = [nys; mean(nthetas{t}.^2)];
    nyerrs = [nyerrs; var(nthetas{t}.^2)];%/sqrt(numel(nthetas{t}))];
end
errorbar(xs,pys,pyerrs,'r','LineWidth',2);
hold on
errorbar(xs,nys,nyerrs,'b','LineWidth',2);
xlim([0 80]);
set(gca,'FontSize',12);
xlabel('\tau');
ylabel('\langle \theta^2 \rangle')
set(gca,'YScale','log');
set(gca,'XScale','log');
plot([2 10], [0.1 0.1/sqrt(2)*sqrt(10)], 'k', 'LineWidth', 2);
plot([2 10], [0.01 0.01/2*10], 'k', 'LineWidth', 2);

%%
figure
pys = [];
xs = [];
pyerrs = [];
nys = [];
nyerrs = [];
for t = 1:numel(taus)
    xs = [xs; taus(t)];
    pys = [pys; mean(cos(pthetas{t}))];
    pyerrs = [pyerrs; std(cos(pthetas{t}))];%/sqrt(numel(pthetas{t}))];
    nys = [nys; mean(cos(nthetas{t}))];
    nyerrs = [nyerrs; std(cos(nthetas{t}))];%/sqrt(numel(pthetas{t}))];
end
errorbar(xs,pys,pyerrs.^2,'r','LineWidth',2);
hold on
errorbar(xs,nys,nyerrs.^2,'b','LineWidth',2);
xlim([0 80]);
set(gca,'FontSize',12);
xlabel('\tau');
ylabel('\langle d(t) \cdot d(t+\tau) \rangle')

%%

figure
plot(eds(2:end) - (eds(2)-eds(1))/2,pdang(1,:),'r','LineWidth',2);
hold on
%plot(eds(2:end) - (eds(2)-eds(1))/2,pdang(2,:),'r','LineWidth',2);
plot(eds(2:end) - (eds(2)-eds(1))/2,pdang(30,:),'r--','LineWidth',2);

%figure
plot(eds(2:end) - (eds(2)-eds(1))/2,ndang(1,:),'b','LineWidth',2);
hold on
%plot(eds(2:end) - (eds(2)-eds(1))/2,ndang(2,:),'b','LineWidth',2);
plot(eds(2:end) - (eds(2)-eds(1))/2,ndang(30,:),'b--','LineWidth',2);
legend(["q = + | \Delta t = 1" "q = + | \Delta t = 30" "q = -  | \Delta t = 1" "q = -  | \Delta t = 30"])
set(gca,"FontSize",12)
xlabel("\Delta \theta")
ylabel("Probability")
%xlim([-pi/3 pi/3])
xticks([-pi/3 -pi/6 0 pi/6 pi/3])
xticklabels(["-\pi/3" "-\pi/6" "0" "\pi/6" "\pi/3"])

%%
show(pdang)
