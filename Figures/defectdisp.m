function defectdisp(datapath)
%% Calculate average director field around defects.

addpath('../Director field');
fpaths = getfold(datapath);

imsize = 401;

pavgdx = zeros(imsize,imsize);
pavgdy = zeros(imsize,imsize);
pcount = zeros(imsize,imsize);

navgdx = zeros(imsize,imsize);
navgdy = zeros(imsize,imsize);
ncount = zeros(imsize,imsize);

for f = 1:numel(fpaths)
    fpath = fpaths{f};

    adefs = alldefects(fpath);

    for i = 1:numel(adefs)

        dir = loaddata(fpath,adefs(i).ts,'dfield','float');
        dir = padarray(dir,[imsize,imsize],NaN,'both');
        angle = atan2d(adefs(i).d(2),adefs(i).d(1));

        if adefs(i).q > 0
            cdir = dir(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                round(adefs(i).x):round(adefs(i).x+2*imsize));
            cdir = imrotate(cdir,angle,'nearest','crop');
            cdir = cdir((imsize+1)/2+1:end-(imsize+1)/2,...
                (imsize+1)/2+1:end-(imsize+1)/2);
            countdir = ~isnan(cdir);
            cdir = cdir-angle*pi/180;
            dx = cos(2*cdir);
            dy = sin(2*cdir);
            dx(isnan(cdir)) = 0;
            dy(isnan(cdir)) = 0;
            
            pavgdx=pavgdx+dx;
            pavgdy=pavgdy+dy;
            pcount = pcount+countdir;
            
        elseif adefs(i).q < 0
            cdir = dir(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                round(adefs(i).x):round(adefs(i).x+2*imsize));
            cdir = imrotate(cdir,angle,'nearest','crop');
            cdir = cdir((imsize+1)/2+1:end-(imsize+1)/2,...
                (imsize+1)/2+1:end-(imsize+1)/2);
            countdir = ~isnan(cdir);
            cdir = cdir-angle*pi/180;
            dx = cos(2*cdir);
            dy = sin(2*cdir);
            dx(isnan(cdir)) = 0;
            dy(isnan(cdir)) = 0;
            
            navgdx = navgdx+dx;
            navgdy = navgdy+dy;
            ncount = ncount+countdir;
            
            cdir = dir(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                round(adefs(i).x):round(adefs(i).x+2*imsize));
            cdir = imrotate(cdir,angle+120,'nearest','crop');
            cdir = cdir((imsize+1)/2+1:end-(imsize+1)/2,...
                (imsize+1)/2+1:end-(imsize+1)/2);
            countdir = ~isnan(cdir);
            cdir = cdir-(angle+120)*pi/180;
            dx = cos(2*cdir);
            dy = sin(2*cdir);
            dx(isnan(cdir)) = 0;
            dy(isnan(cdir)) = 0;
            
            navgdx = navgdx+dx;
            navgdy = navgdy+dy;
            ncount = ncount+countdir;
            
            cdir = dir(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                round(adefs(i).x):round(adefs(i).x+2*imsize));
            cdir = imrotate(cdir,angle+240,'nearest','crop');
            cdir = cdir((imsize+1)/2+1:end-(imsize+1)/2,...
                (imsize+1)/2+1:end-(imsize+1)/2);
            countdir = ~isnan(cdir);
            cdir = cdir-(angle+240)*pi/180;
            dx = cos(2*cdir);
            dy = sin(2*cdir);
            dx(isnan(cdir)) = 0;
            dy(isnan(cdir)) = 0;
            
            navgdx = navgdx+dx;
            navgdy = navgdy+dy;
            ncount = ncount+countdir;
        end
    end
end

pavgdx = pavgdx./pcount;
pavgdy = pavgdy./pcount;
navgdx = navgdx./ncount;
navgdy = navgdy./ncount;

pmag = sqrt(pavgdx.^2+pavgdy.^2);
nmag = sqrt(navgdx.^2+navgdy.^2);

cdir = atan2(pavgdy,pavgdx);
pavgdx = pmag.*cos(cdir/2);
pavgdy = pmag.*sin(cdir/2);

cdir = atan2(navgdy,navgdx);
navgdx = nmag.*cos(cdir/2);
navgdy = nmag.*sin(cdir/2);

%% Plot positive ones
load('orientcmap','mymap');
fig = figure('Units','pixels','Position',[200 200 403 403]);

ax = axes(fig,'Units','pixels','Position',[2 2 401 401],'FontSize', 38,...
    'Visible','on','FontName', 'Latin Modern Math','layer','top','box','on',...
    'TickLength',[0.03 0.03],'LineWidth',2,'ColorMap',colorcet('C2'),'YDir','reverse');
hold(ax,'on')
surf(ax,atan2(pavgdy,pavgdx),'EdgeColor','none');
colormap(mymap);
xticks(201-20/0.133:10/0.133:201+20/0.133)
yticks(201-20/0.133:10/0.133:201+20/0.133)
% yticklabels(["20   " "10   " "0   " "-10   " "-20   "]);
% xticklabels(-20:10:20)
xlim([201-20/0.133 201+20/0.133])
ylim([201-20/0.133 201+20/0.133])
% ylabel('$y ({\mu}$m$)$','Interpreter','latex')
% xlabel('$x ({\mu}$m$)$','Interpreter','latex','Position',[201 447 2])

t = linspace(0,2*pi);
a = 20;
b = 3;
X = a*cos(t);
Y = b*sin(t);

%% Add streamlines to positive ones.

pts = [100 211; 61 216; 140 203; 170 201; 192 200; 210 200; 204 193; 207 209;...
    192 201; 170 202; 140 204; 100 212; 61 217];
ls = 250*ones(numel(pts)/2,1);
for i = 1:numel(ls)
    sld = sl(pavgdx,pavgdy,pts(i,:),ls(i));
    plot3(sld(:,1),sld(:,2),5*ones(size(sld(:,1))),'k','LineWidth',2);
end

pts1 = [192 201; 170 201; 140 203; 100 211; 61 217];
pts2 = [192 200; 170 202; 140 204; 100 212; 61 216];
for i = 1:numel(pts1)/2
    plot3([pts1(i,1) pts2(i,1)],[pts1(i,2) pts2(i,2)],5*ones(2,1),'k','LineWidth',2);
end

%% Add elipses to positive ones.

while true
    [xx, yy] = ginput(1);
    xx = round(xx);
    yy = round(yy);
    
    w = atan2(pavgdy(yy,xx),pavgdx(yy,xx));
    x = xx + X*cos(w) - Y*sin(w);
    y = yy + X*sin(w) + Y*cos(w);
    plot3(x,y,3*ones(size(x)),'k','LineWidth',1.5)
end


%% Plot negative ones
load('orientcmap','mymap');

fig = figure('Units','pixels','Position',[200 200 403 403]);

ax = axes(fig,'Units','pixels','Position',[2 2 401 401],'FontSize', 38,...
    'Visible','on','FontName', 'Latin Modern Math','layer','top','box','on',...
    'TickLength',[0.03 0.03],'LineWidth',2,'ColorMap',colorcet('C2'),'XDir','reverse');
hold(ax,'on')
surf(ax,atan2(navgdy,navgdx),'EdgeColor','none');
colormap(mymap);
xticks(201-20/0.133:10/0.133:201+20/0.133)
yticks(201-20/0.133:10/0.133:201+20/0.133)
yticklabels(["20   " "10   " "0   " "-10   " "-20   "]);
xticklabels(20:-10:-20)
xlim([201-20/0.133 201+20/0.133])
ylim([201-20/0.133 201+20/0.133])
ylabel('$y ({\mu}$m$)$','Interpreter','latex')
xlabel('$x ({\mu}$m$)$','Interpreter','latex','Position',[201 -15 1])

t = linspace(0,2*pi);
a = 20;
b = 3;
X = a*cos(t);
Y = b*sin(t);

%% Add streamlines to negative ones


pts = [175 400; 210 400; 140 400; 120 400; 106 400; ...
    270 50; 210 50; 160 50; 125 50];
ls = 400*ones(numel(pts)/2,1);
for i = 1:numel(ls)
    sld = sl(navgdx,navgdy,pts(i,:),ls(i));
    plot3(sld(:,1),sld(:,2),5*ones(size(sld(:,1))),'k','LineWidth',2);
end

pts = [175 202; 175 201; 142 202; 142 203; 106 208; 106 209; 72 213; 72 212];
ls = 400*ones(numel(pts)/2,1);

for i = 1:numel(ls)
    sld = sl(-navgdx,-navgdy,pts(i,:),ls(i));
    plot3(sld(:,1),sld(:,2),5*ones(size(sld(:,1))),'k','LineWidth',2);
end

pts1 = [175 202; 142 202; 106 208; 72 213];
pts2 = [175 201; 142 203; 106 209; 72 212];
for i = 1:numel(pts1)/2
    plot3([pts1(i,1) pts2(i,1)],[pts1(i,2) pts2(i,2)],5*ones(2,1),'k','LineWidth',2);
end


%% Add elipses to negative defs.

while true
    [xx, yy] = ginput(1);
    xx = round(xx);
    yy = round(yy);

    w = atan2(navgdy(yy,xx),navgdx(yy,xx));
    x = xx + X*cos(w) - Y*sin(w);
    y = yy + X*sin(w) + Y*cos(w);
    plot3(x,y,3*ones(size(x)),'k','LineWidth',1.5)
end
