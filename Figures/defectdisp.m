function defectdisp(datapath)
%% Calculate average directions

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


fig = figure('Units','pixels','Position',[200 200 403 403]);

ax = axes(fig,'Units','pixels','Position',[2 2 401 401],'FontSize', 38,...
    'Visible','on','FontName', 'Latin Modern Math','layer','top','box','on',...
    'TickLength',[0.03 0.03],'LineWidth',2,'ColorMap',colorcet('C2'),'YDir','reverse');
hold(ax,'on')
surf(ax,atan2(pavgdy,pavgdx),'EdgeColor','none');
colorcet('C2')
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

%%
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



fig = figure('Units','pixels','Position',[200 200 403 403]);

ax = axes(fig,'Units','pixels','Position',[2 2 401 401],'FontSize', 38,...
    'Visible','on','FontName', 'Latin Modern Math','layer','top','box','on',...
    'TickLength',[0.03 0.03],'LineWidth',2,'ColorMap',colorcet('C2'),'XDir','reverse');
hold(ax,'on')
surf(ax,atan2(navgdy,navgdx),'EdgeColor','none');
colorcet('C2')
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


%%

while true
    [xx, yy] = ginput(1);
    xx = round(xx);
    yy = round(yy);
    
    w = atan2(navgdy(yy,xx),navgdx(yy,xx));
    x = xx + X*cos(w) - Y*sin(w);
    y = yy + X*sin(w) + Y*cos(w);
    plot3(x,y,3*ones(size(x)),'k','LineWidth',1.5)
end