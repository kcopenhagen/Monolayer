function defectvelcorrall(datapath)
%%
addpath('../');

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
sps = [1 2 3 5 9 15 31 51];

eds = 0:pi^2/240:pi^2/2;
taus = 1:50;

for sp = sps
    mf = 1/sp*ones(sp,1);

    pdang = zeros(numel(taus),numel(eds)-1);
    vdang = zeros(numel(taus),numel(eds)-1);

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
            vx = x2-x;
            vy = y2-y;
            vx = conv(vx,mf,'valid');
            vy = conv(vy,mf,'valid');
            v = sqrt(vx.^2+vy.^2);

            d = [adefs([adefs.id]==id).d];
            dx = d(1:2:end-3);
            dy = d(2:2:end-2);
            dx2 = dx*cos(2*pi/3)-dy*sin(2*pi/3);
            dy2 = dx*sin(2*pi/3)+dy*cos(2*pi/3);
            dx3 = dx*cos(4*pi/3)-dy*sin(4*pi/3);
            dy3 = dx*sin(4*pi/3)+dy*cos(4*pi/3);
            dx = conv(dx,mf,'valid');
            dy = conv(dy,mf,'valid');
            dd = sqrt(dx.^2+dy.^2);

            if q(1) > 0
                for tau = taus

                    for t = 1:numel(dx)-tau
                        theta = acos((dx(t)*dx(t+tau)+dy(t)*dy(t+tau))/(dd(t)*dd(t+tau)));
                        bintheta = histcounts(theta.^2,eds);
                        pdang(tau,:) = pdang(tau,:) + bintheta;
                        thetav = acos((vx(t)*vx(t+tau)+vy(t)*vy(t+tau))/(v(t)*v(t+tau)));
                        thetav = abs(thetav);
                        binthetav = histcounts(thetav.^2,eds);
                        vdang(tau,:) = vdang(tau,:) + binthetav;
                    end

                end
            end
        end
    end

    meanpd = zeros(numel(pdang(:,1)),1);
    meanpv = zeros(numel(pdang(:,1)),1);
    for i = 1:numel(pdang(:,1))
        pdang(i,:) = pdang(i,:)/sum(pdang(i,:));
        vdang(i,:) = vdang(i,:)/sum(vdang(i,:));
        meanpd(i) = sum(pdang(i,:).*(eds(2:end) - eds(1)/2));
        meanpv(i) = sum(vdang(i,:).*(eds(2:end) - eds(1)/2));
    end
    
    ys = taus';
    show(pdang)
    hold on
    xs = meanpd;
    fd = fit(xs,ys,'poly1');
    plot(xs,fd(xs),'b','LineWidth',2);
    plot(xs,ys,'r.','MarkerSize',10);
    msg = sprintf("< theta^2 > = %f * t + %f",1/fd.p1,-fd.p2/fd.p1);
    msg2 = sprintf("Averaged over: %d frames",sp);
    text(numel(xs)/2,numel(ys)/2,msg,'Color','w');
    text(numel(xs)/2,numel(ys)/2+10,msg2,'Color','w');
    drawnow
    
    show(vdang)
    hold on
    xs = meanpv;
    fd = fit(xs,ys,'poly1');
    plot(xs,fd(xs),'b','LineWidth',2);
    plot(xs,ys,'r.','MarkerSize',10);
    msg = sprintf("< theta^2 > = %f * t + %f",1/fd.p1,-fd.p2/fd.p1);
    msg2 = sprintf("Averaged over: %d frames",sp);
    text(numel(xs)/2,numel(ys)/2,msg,'Color','w');
    text(numel(xs)/2,numel(ys)/2+10,msg2,'Color','w');
    drawnow
    
end
