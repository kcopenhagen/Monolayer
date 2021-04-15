function flowplots(datapath)
addpath('../../Director field');
%% Calculate all the things.

    imsize = 401;
    pavgvx = zeros(imsize,imsize);
    pavgvxn = zeros(imsize,imsize);
    pavgvy = zeros(imsize,imsize);
    pavgvyn = zeros(imsize,imsize);
    navgvx = zeros(imsize,imsize);
    navgvxn = zeros(imsize,imsize);
    navgvy = zeros(imsize,imsize);
    navgvyn = zeros(imsize,imsize);
    
    fpaths = getfold(datapath);

    for f = 7%:numel(fpaths)
        fpath = fpaths{f};
        load([fpath 'adefs.mat'],'adefs');
        
        for i = 1:numel(adefs)
            
            
            if true
                vx = loaddata(fpath,adefs(i).ts,'flows/Vx','float');
                vy = loaddata(fpath,adefs(i).ts,'flows/Vy','float');
                vx = padarray(vx,[imsize,imsize],NaN,'both');
                vy = padarray(vy,[imsize,imsize],NaN,'both');
                zerovs = vx+vy==0;
                vx(zerovs) = NaN;
                vy(zerovs) = NaN;

                if adefs(i).q > 0 
                    angle = -atan2d(adefs(i).d(2),adefs(i).d(1));
                    cvx = vx(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                        round(adefs(i).x):round(adefs(i).x+2*imsize));
                    cvy = vy(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                        round(adefs(i).x):round(adefs(i).x+2*imsize));

                    cvx = imrotate(cvx,-angle,'nearest','crop');
                    cvx = cvx((imsize+1)/2+1:end-(imsize+1)/2,...
                        (imsize+1)/2+1:end-(imsize+1)/2);
                    countvx = ~isnan(cvx);
                    cvx(isnan(cvx)) = 0;


                    cvy = imrotate(cvy,-angle,'nearest','crop');
                    cvy = cvy((imsize+1)/2+1:end-(imsize+1)/2,...
                        (imsize+1)/2+1:end-(imsize+1)/2);
                    countvy = ~isnan(cvy);
                    cvy(isnan(cvy)) = 0;

                    cvxt = cvx*cosd(angle)-cvy*sind(angle);
                    cvy = cvx*sind(angle)+cvy*cosd(angle);
                    cvx = cvxt;

                    pavgvx = pavgvx + cvx;
                    pavgvxn = pavgvxn + countvx;                
                    pavgvy = pavgvy + cvy;
                    pavgvyn = pavgvyn + countvy;

                elseif adefs(i).q<0
                    %Rotate to d.
                    angle = -atan2d(adefs(i).d(2),adefs(i).d(1));
                    cvx = vx(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                        round(adefs(i).x):round(adefs(i).x+2*imsize));
                    cvy = vy(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                        round(adefs(i).x):round(adefs(i).x+2*imsize));

                    cvx = imrotate(cvx,-angle,'nearest','crop');
                    cvx = cvx((imsize+1)/2+1:end-(imsize+1)/2,...
                        (imsize+1)/2+1:end-(imsize+1)/2);
                    countvx = ~isnan(cvx);
                    cvx(isnan(cvx)) = 0;

                    cvy = imrotate(cvy,-angle,'nearest','crop');
                    cvy = cvy((imsize+1)/2+1:end-(imsize+1)/2,...
                        (imsize+1)/2+1:end-(imsize+1)/2);
                    countvy = ~isnan(cvy);
                    cvy(isnan(cvy)) = 0;

                    cvxt = cvx*cosd(angle)-cvy*sind(angle);
                    cvy = cvx*sind(angle)+cvy*cosd(angle);
                    cvx = cvxt;

                    navgvx = navgvx + cvx;
                    navgvxn = navgvxn + countvx;
                    navgvy = navgvy + cvy;
                    navgvyn = navgvyn + countvy;

                    %Rotate to d + 120.
                    angle = -atan2d(adefs(i).d(2),adefs(i).d(1))+120;
                    cvx = vx(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                        round(adefs(i).x):round(adefs(i).x+2*imsize));
                    cvy = vy(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                        round(adefs(i).x):round(adefs(i).x+2*imsize));

                    cvx = imrotate(cvx,-angle,'nearest','crop');
                    cvx = cvx((imsize+1)/2+1:end-(imsize+1)/2,...
                        (imsize+1)/2+1:end-(imsize+1)/2);
                    countvx = ~isnan(cvx);
                    cvx(isnan(cvx)) = 0;

                    cvy = imrotate(cvy,-angle,'nearest','crop');
                    cvy = cvy((imsize+1)/2+1:end-(imsize+1)/2,...
                        (imsize+1)/2+1:end-(imsize+1)/2);
                    countvy = ~isnan(cvy);
                    cvy(isnan(cvy)) = 0;

                    cvxt = cvx*cosd(angle)-cvy*sind(angle);
                    cvy = cvx*sind(angle)+cvy*cosd(angle);
                    cvx = cvxt;

                    navgvx = navgvx + cvx;
                    navgvxn = navgvxn + countvx;
                    navgvy = navgvy + cvy;
                    navgvyn = navgvyn + countvy;

                    %Rotate to d+240
                    angle = -atan2d(adefs(i).d(2),adefs(i).d(1))+240;

                    cvx = vx(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                        round(adefs(i).x):round(adefs(i).x+2*imsize));
                    cvx = imrotate(cvx,-angle,'nearest','crop');
                    cvx = cvx((imsize+1)/2+1:end-(imsize+1)/2,...
                        (imsize+1)/2+1:end-(imsize+1)/2);
                    countvx = ~isnan(cvx);
                    cvx(isnan(cvx)) = 0;

                    cvy = vy(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                        round(adefs(i).x):round(adefs(i).x+2*imsize));
                    cvy = imrotate(cvy,-angle,'nearest','crop');
                    cvy = cvy((imsize+1)/2+1:end-(imsize+1)/2,...
                        (imsize+1)/2+1:end-(imsize+1)/2);
                    countvy = ~isnan(cvy);
                    cvy(isnan(cvy)) = 0;

                    cvxt = cvx*cosd(angle)-cvy*sind(angle);
                    cvy = cvx*sind(angle)+cvy*cosd(angle);
                    cvx = cvxt;

                    navgvx = navgvx + cvx;
                    navgvxn = navgvxn + countvx;
                    navgvy = navgvy + cvy;
                    navgvyn = navgvyn + countvy;

                end
            end
        end
    end

pavgvx = pavgvx./pavgvxn;
pavgvy = pavgvy./pavgvyn;
navgvx = navgvx./navgvxn;
navgvy = navgvy./navgvyn;

%% Calculate standard deviations.

pstdvx = zeros(imsize,imsize);
pstdvy = zeros(imsize,imsize);
nstdvx = zeros(imsize,imsize);
nstdvy = zeros(imsize,imsize);

fpaths = getfold(datapath);

for f = 1:numel(fpaths)
    fpath = fpaths{f};
    load([fpath 'adefs.mat'],'adefs');

    for i = 1:numel(adefs)


        if true
            vx = loaddata(fpath,adefs(i).ts,'flows/Vx','float');
            vy = loaddata(fpath,adefs(i).ts,'flows/Vy','float');
            vx = padarray(vx,[imsize,imsize],NaN,'both');
            vy = padarray(vy,[imsize,imsize],NaN,'both');
            zerovs = vx+vy==0;
            vx(zerovs) = NaN;
            vy(zerovs) = NaN;

            if adefs(i).q > 0 
                angle = -atan2d(adefs(i).d(2),adefs(i).d(1));
                cvx = vx(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                    round(adefs(i).x):round(adefs(i).x+2*imsize));
                cvy = vy(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                    round(adefs(i).x):round(adefs(i).x+2*imsize));

                cvx = imrotate(cvx,-angle,'nearest','crop');
                cvx = cvx((imsize+1)/2+1:end-(imsize+1)/2,...
                    (imsize+1)/2+1:end-(imsize+1)/2);
                countvx = ~isnan(cvx);
                cvx(isnan(cvx)) = 0;


                cvy = imrotate(cvy,-angle,'nearest','crop');
                cvy = cvy((imsize+1)/2+1:end-(imsize+1)/2,...
                    (imsize+1)/2+1:end-(imsize+1)/2);
                countvy = ~isnan(cvy);
                cvy(isnan(cvy)) = 0;

                cvxt = cvx*cosd(angle)-cvy*sind(angle);
                cvy = cvx*sind(angle)+cvy*cosd(angle);
                cvx = cvxt;

                pstdvx = pstdvx + (cvx - pavgvx).^2;
                pstdvy = pstdvy + (cvy - pavgvy).^2;

            elseif adefs(i).q<0
                %Rotate to d.
                angle = -atan2d(adefs(i).d(2),adefs(i).d(1));
                cvx = vx(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                    round(adefs(i).x):round(adefs(i).x+2*imsize));
                cvy = vy(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                    round(adefs(i).x):round(adefs(i).x+2*imsize));

                cvx = imrotate(cvx,-angle,'nearest','crop');
                cvx = cvx((imsize+1)/2+1:end-(imsize+1)/2,...
                    (imsize+1)/2+1:end-(imsize+1)/2);
                countvx = ~isnan(cvx);
                cvx(isnan(cvx)) = 0;

                cvy = imrotate(cvy,-angle,'nearest','crop');
                cvy = cvy((imsize+1)/2+1:end-(imsize+1)/2,...
                    (imsize+1)/2+1:end-(imsize+1)/2);
                countvy = ~isnan(cvy);
                cvy(isnan(cvy)) = 0;

                cvxt = cvx*cosd(angle)-cvy*sind(angle);
                cvy = cvx*sind(angle)+cvy*cosd(angle);
                cvx = cvxt;

                nstdvx = nstdvx + (cvx - navgvx).^2;
                nstdvy = nstdvy + (cvy - navgvy).^2;

                %Rotate to d + 120.
                angle = -atan2d(adefs(i).d(2),adefs(i).d(1))+120;
                cvx = vx(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                    round(adefs(i).x):round(adefs(i).x+2*imsize));
                cvy = vy(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                    round(adefs(i).x):round(adefs(i).x+2*imsize));

                cvx = imrotate(cvx,-angle,'nearest','crop');
                cvx = cvx((imsize+1)/2+1:end-(imsize+1)/2,...
                    (imsize+1)/2+1:end-(imsize+1)/2);
                countvx = ~isnan(cvx);
                cvx(isnan(cvx)) = 0;

                cvy = imrotate(cvy,-angle,'nearest','crop');
                cvy = cvy((imsize+1)/2+1:end-(imsize+1)/2,...
                    (imsize+1)/2+1:end-(imsize+1)/2);
                countvy = ~isnan(cvy);
                cvy(isnan(cvy)) = 0;

                cvxt = cvx*cosd(angle)-cvy*sind(angle);
                cvy = cvx*sind(angle)+cvy*cosd(angle);
                cvx = cvxt;


                nstdvx = nstdvx + (cvx - navgvx).^2;
                nstdvy = nstdvy + (cvy - navgvy).^2;

                %Rotate to d+240
                angle = -atan2d(adefs(i).d(2),adefs(i).d(1))+240;

                cvx = vx(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                    round(adefs(i).x):round(adefs(i).x+2*imsize));
                cvx = imrotate(cvx,-angle,'nearest','crop');
                cvx = cvx((imsize+1)/2+1:end-(imsize+1)/2,...
                    (imsize+1)/2+1:end-(imsize+1)/2);
                countvx = ~isnan(cvx);
                cvx(isnan(cvx)) = 0;

                cvy = vy(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                    round(adefs(i).x):round(adefs(i).x+2*imsize));
                cvy = imrotate(cvy,-angle,'nearest','crop');
                cvy = cvy((imsize+1)/2+1:end-(imsize+1)/2,...
                    (imsize+1)/2+1:end-(imsize+1)/2);
                countvy = ~isnan(cvy);
                cvy(isnan(cvy)) = 0;

                cvxt = cvx*cosd(angle)-cvy*sind(angle);
                cvy = cvx*sind(angle)+cvy*cosd(angle);
                cvx = cvxt;

                nstdvx = nstdvx + (cvx - navgvx).^2;
                nstdvy = nstdvy + (cvy - navgvy).^2;

            end
        end
    end
end
    
pstdvx = sqrt(pstdvx./pavgvxn);
pstdvy = sqrt(pstdvy./pavgvyn);
nstdvx = sqrt(nstdvx./navgvxn);
nstdvy = sqrt(nstdvy./navgvyn);

%% Plot positive ones
% Flow factor = 84microns/minute.
quivsp = 20;
x = 1:imsize;
y = 1:imsize;
[xx,yy] = meshgrid(x,y);
rr = sqrt((xx-(imsize-1)/2).^2+(yy-(imsize-1)/2).^2);

im = real2rgb(sqrt(pavgvx.^2+pavgvy.^2),colorcet('L8'),[0 0.014]);

show(im)
hold on
xgrid = 1:quivsp:imsize;
ygrid = 1:quivsp:imsize;
[xquiv, yquiv] = meshgrid(xgrid,ygrid);
gridinds = sub2ind(size(im),yquiv,xquiv);


uquiv = pavgvx(gridinds);
vquiv = pavgvy(gridinds);

quiver(xquiv,yquiv,uquiv,vquiv,'w','LineWidth',2);
plot([200 200],[0 400],'--','Color',[184 218 70]/255,'LineWidth',2);
plot([0 400],[200 200],'--','Color',[184 218 70]/255,'LineWidth',2);

xlim([50 350])
ylim([50 350])
axis on
set(gca,'TickDir','in','LineWidth',2)
xticks([50 125 200 275 350])
yticks([50 125 200 275 350])
xticklabels([])
yticklabels([])
% thetas = 0:0.01:2*pi;
% cx = msz*cos(thetas)+200;
% cy = msz*sin(thetas)+200;
% plot(cx,cy,'b','LineWidth',1);

%% Plot negative ones

quivsp = 15;
x = 1:imsize;
y = 1:imsize;
[xx,yy] = meshgrid(x,y);
rr = sqrt((xx-(imsize-1)/2).^2+(yy-(imsize-1)/2).^2);

im = real2rgb(sqrt(navgvx.^2+navgvy.^2),colorcet('L8'),[0 0.0081]);

show(im)
hold on
xgrid = 1:quivsp:imsize;
ygrid = 1:quivsp:imsize;
[xquiv, yquiv] = meshgrid(xgrid,ygrid);
gridinds = sub2ind(size(im),yquiv,xquiv);

uquiv = navgvx(gridinds);
vquiv = navgvy(gridinds);

quiver(xquiv,yquiv,uquiv,vquiv,'w','LineWidth',2);
plot([200 200],[0 400],'--','Color',[184 218 70]/255,'LineWidth',2);
plot([0 400],[200 200],'--','Color',[184 218 70]/255,'LineWidth',2);

xlim([50 350])
ylim([50 350])
axis on
set(gca,'TickDir','in','LineWidth',2)
xticks([50 125 200 275 350])
yticks([50 125 200 275 350])
xticklabels([])
yticklabels([])
% thetas = 0:0.01:2*pi;
% cx = msz*cos(thetas)+200;
% cy = msz*sin(thetas)+200;
% plot(cx,cy,'b','LineWidth',1);


%% Divergence plots
cmap = colorcet('D1');
sm = 15;
figure('Units','pixels','Position',[300 100 340 660])

thetas = 0:pi/20:2*pi;
pvxs = imgaussfilt(pavgvx,sm);
pvys = imgaussfilt(pavgvy,sm);
nvxs = imgaussfilt(navgvx,sm);
nvys = imgaussfilt(navgvy,sm);

x = 1:imsize;
y = 1:imsize;
[xx,yy] = meshgrid(x,y);
rr = sqrt((xx-(imsize-1)/2).^2+(yy-(imsize-1)/2).^2);
circ = rr<(imsize-1)/2;

[Fxx,~] = gradient(pvxs);
[~,Fyy] = gradient(pvys);
pdiv = Fxx+Fyy;
[Fxx,~] = gradient(nvxs);
[~,Fyy] = gradient(nvys);
ndiv = Fxx+Fyy;
ulim = max(max(ndiv(:)),max(pdiv(:)));
llim = min(min(ndiv(:)),min(pdiv(:)));
clims = 0.9*[-max(abs(ulim),abs(llim)),max(abs(ulim),abs(llim))];

axes('Units','pixels','Position',[20 340 300 300]);
im = real2rgb(pdiv,cmap,clims);
img = image(im);
img.AlphaData = circ;
axis off
hold on
plot(45*cos(thetas)+200,45*sin(thetas)+200,'k--','LineWidth',1)
plot(200*cos(thetas)+200,200*sin(thetas)+200,'k','LineWidth',1)

axes('Units','pixels','Position',[20 20 300 300]);
im = real2rgb(ndiv,cmap,clims);
img = image(im);
img.AlphaData = circ;
axis off
hold on
plot(45*cos(thetas)+200,45*sin(thetas)+200,'k--','LineWidth',1)
plot(200*cos(thetas)+200,200*sin(thetas)+200,'k','LineWidth',1)

%% Save data to text files.

pavgvxc = pavgvx*86;
pavgvyc = pavgvy*86;

pstdvxc = pstdvx*86;
pstdvyc = pstdvy*86;

navgvxc = navgvx*86;
navgvyc = navgvy*86;

nstdvxc = nstdvx*86;
nstdvyc = nstdvy*86;

save('txtfiles/pavgvx.txt', 'pavgvxc', '-ascii', '-double', '-tabs')
save('txtfiles/pavgvy.txt', 'pavgvyc', '-ascii', '-double', '-tabs')
save('txtfiles/pn.txt', 'pavgvxn', '-ascii', '-double', '-tabs')
save('txtfiles/pstdvx.txt', 'pstdvxc', '-ascii', '-double', '-tabs')
save('txtfiles/pstdvy.txt', 'pstdvyc', '-ascii', '-double', '-tabs')

save('txtfiles/navgvx.txt', 'navgvxc', '-ascii', '-double', '-tabs')
save('txtfiles/navgvy.txt', 'navgvyc', '-ascii', '-double', '-tabs')
save('txtfiles/nn.txt', 'navgvxn', '-ascii', '-double', '-tabs')
save('txtfiles/nstdvx.txt', 'nstdvxc', '-ascii', '-double', '-tabs')
save('txtfiles/nstdvy.txt', 'nstdvyc', '-ascii', '-double', '-tabs')

%% Plot perpendicular component at d.

d = 75;

xdis = xx-201;
ydis = yy-201;
rdis = sqrt(xdis.^2+ydis.^2);

circ = zeros(size(rdis));
circ(rdis>d)=1;
circ(rdis>d+1)=0;

ptsx = xdis(circ==1);
ptsy = ydis(circ==1);
pvxatd = pavgvxc(circ==1);
pvyatd = pavgvyc(circ==1);

nvxatd = navgvxc(circ==1);
nvyatd = navgvyc(circ==1);


phis = atan2(ptsy,ptsx);
phis(phis<0) = phis(phis<0)+2*pi;
phis = 2*pi-phis;
rxnorm = xdis./rdis;
rynorm = ydis./rdis;

pperpcomp = pvxatd.*rxnorm(circ==1)+pvyatd.*rynorm(circ==1);
nperpcomp = nvxatd.*rxnorm(circ==1)+nvyatd.*rynorm(circ==1);
figure
plot(phis,pperpcomp,'r.');
hold on
plot(phis,nperpcomp,'b.');


