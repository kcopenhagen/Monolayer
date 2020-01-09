function directedmotion(datapath)

addpath('../');

folders = getfold(datapath);

vps = [];
vns = [];
aps = [];
an = [];
figure
for tau = 1:5:51
    %tau = 10; %Number of frames to average over.
    mf = 1/tau * ones(tau,1);

    for f = 1:numel(folders)

        fpath = folders{f};
        XYcal = getXYcal(fpath);

        load([fpath 'adefs.mat'],'adefs');

        ids = unique([adefs.id]);
        for ij = 1:numel(ids)
            id = ids(ij);
            x = [adefs([adefs.id]==id).x];
            y = [adefs([adefs.id]==id).y];
            t = [adefs([adefs.id]==id).tt]/60;
            q = [adefs([adefs.id]==id).q];

            x2 = x(2:end);
            x(end) = [];
            y2 = y(2:end);
            y(end) = [];
            t2 = t(2:end);
            t(end) = [];

            vx = XYcal*(x2-x)./(t2-t);
            vy = XYcal*(y2-y)./(t2-t);
            vx = conv(vx,mf,'valid');
            vy = conv(vy,mf,'valid');
            v = sqrt(vx.^2+vy.^2);

            d = [adefs([adefs.id]==id).d];
            dx = d(1:2:end-3);
            dy = d(2:2:end-2);
            dx = conv(dx,mf,'valid');
            dy = conv(dy,mf,'valid');
            dx2 = dx*cos(2*pi/3)-dy*sin(2*pi/3);
            dy2 = dx*sin(2*pi/3)+dy*cos(2*pi/3);
            dx3 = dx*cos(4*pi/3)-dy*sin(4*pi/3);
            dy3 = dx*sin(4*pi/3)+dy*cos(4*pi/3);
            dd = sqrt(dx.^2+dy.^2);

            if q(1) > 0
                vps = [vps;v'];
                ang = acos((vx.*dx+vy.*dy)./(v.*dd));
                aps = [aps;ang'];
            elseif q(1) < 0
                vns = [vns;v'];
                ang1 = acos((vx.*dx+vy.*dy)./(v.*dd));
                ang2 = acos((vx.*dx2+vy.*dy2)./(v.*dd));
                ang3 = acos((vx.*dx3+vy.*dy3)./(v.*dd));
                ang = min(ang1,min(ang2,ang3));
                an = [an;ang'];
            end
        end
    end

    %Positive defects
    eds = 0:pi/30:pi;
    pangs = histcounts(aps,eds,'Normalization','pdf');
    r = 1/50*(tau - 1);
    C = [r 0 0];
    plot(eds(2:end)-(eds(2) - eds(1))/2,pangs,'Color',C,'LineWidth',2);
    hold on
    drawnow
end
%% Plot em
figure

%Positive defects
eds = -1:0.1:1;
pangs = histcounts(cos(aps),eds,'Normalization','probability');
pnorm = histcounts(cos(0:0.0001:pi),eds,'Normalization','probability');
%plot(eds(2:end)-(eds(2) - eds(1))/2,pangs./pnorm,'r','LineWidth',2);
plot(-19/20:1/10:1,pangs./pnorm,'r','LineWidth',2);

hold on
%Negative defects
eds = 0.5:.025:1;
nangs = histcounts(cos(an),eds,'Normalization','probability');
nnorm = histcounts(cos(0:0.0001:pi/3),eds,'Normalization','probability');
plot(-19/20:1/10:1,nangs./nnorm,'b','LineWidth',2);

plot([-1 1],[1 1],'k--','LineWidth',2)

%Plot appearance
set(gca,'FontSize',18);
xlabel('Bias');
ylabel('Enhancement');


%% Angle differences
figure

%Positive defects
eds = 0:pi/30:pi;
pangs = histcounts(aps,eds,'Normalization','pdf');
plot(eds(2:end)-(eds(2) - eds(1))/2,pangs,'r','LineWidth',2);

hold on
%Negative defects
eds = 0:pi/30:pi;
an2 = [an; 2*pi/3-an; an+2*pi/3];
nangs = histcounts(an2,eds,'Normalization','pdf');
plot(eds(2:end)-(eds(2) - eds(1))/2,nangs,'b','LineWidth',2);


%Plot appearance
set(gca,'FontSize',18);
xlim([0 pi])
xlabel('\Delta \theta');
ylabel('PDF');
xticks(0:pi/6:pi)
xticklabels(["0"; "\pi/6"; "\pi/3"; "\pi/2"; "2\pi/3"; "5\pi/6"; "\pi"])

%% v plot

figure
eds = 0:0.1:10;
pvs = histcounts(vps,eds,'Normalization','pdf');
nvs = histcounts(vns,eds,'Normalization','pdf');

plot(eds(2:end)-eds(1)/2,pvs,'r','LineWidth',2);
hold on
plot(eds(2:end)-eds(1)/2,nvs,'b','LineWidth',2);
set(gca,'FontSize',18);
xlabel('Speed (\mum /min)');
ylabel('PDF');