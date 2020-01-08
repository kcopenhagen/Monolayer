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
    pavgmag = zeros(imsize,imsize);
    navgmag = zeros(imsize,imsize);
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

                vx(vx+vy==0) = NaN;
                vy(vx+vy==0) = NaN;

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

%% Plot positive ones
% Flow factor = 84microns/minute.
quivsp = 15;
x = 1:imsize;
y = 1:imsize;
[xx,yy] = meshgrid(x,y);
rr = sqrt((xx-(imsize-1)/2).^2+(yy-(imsize-1)/2).^2);

im = real2rgb(sqrt(pavgvx.^2+pavgvy.^2),colorcet('L4'),[0 0.014]);
imr = im(:,:,1);
img = im(:,:,2);
imb = im(:,:,3);
imr(rr>(imsize-1)/2-2) = 0;
img(rr>(imsize-1)/2-2) = 0;
imb(rr>(imsize-1)/2-2) = 0;
imr(rr>(imsize-1)/2) = 1;
img(rr>(imsize-1)/2) = 1;
imb(rr>(imsize-1)/2) = 1;

im(:,:,1) = imr;
im(:,:,2) = img;
im(:,:,3) = imb;

show(im)
hold on
xgrid = 1:quivsp:imsize;
ygrid = 1:quivsp:imsize;
[xquiv, yquiv] = meshgrid(xgrid,ygrid);
gridinds = sub2ind(size(im),yquiv,xquiv);

uquiv = pavgvx(gridinds);
vquiv = pavgvy(gridinds);

quiver(xquiv,yquiv,uquiv,vquiv,'w','LineWidth',2);

thetas = 0:0.01:2*pi;
cx = msz*cos(thetas)+200;
cy = msz*sin(thetas)+200;
plot(cx,cy,'b','LineWidth',1);

%% Plot negative ones

quivsp = 15;
im = real2rgb(sqrt(navgvx.^2+navgvy.^2),colorcet('L4'));%,[0 0.014]);

img = image(im);

x = 1:imsize;
y = 1:imsize;
[xx,yy] = meshgrid(x,y);
rr = sqrt((xx-(imsize-1)/2).^2+(yy-(imsize-1)/2).^2);
circ = rr<(imsize-1)/2;

img.AlphaData = circ;

hold on
xgrid = 1:quivsp:imsize;
ygrid = 1:quivsp:imsize;
[xquiv, yquiv] = meshgrid(xgrid,ygrid);
gridinds = sub2ind(size(im),yquiv,xquiv);

uquiv = navgvx(gridinds);
vquiv = navgvy(gridinds);

quiver(xquiv,yquiv,uquiv,vquiv,'w','LineWidth',2);

thetas = 0:0.01:2*pi;
cx = msz*cos(thetas)+200;
cy = msz*sin(thetas)+200;
plot(cx,cy,'b','LineWidth',1);


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
