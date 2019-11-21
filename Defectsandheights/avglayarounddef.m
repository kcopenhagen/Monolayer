function avglayarounddef(datapath)
addpath('../Director field');
imsize = 401;
folders = getfold(datapath);

clayp = zeros(imsize,imsize);
clayn = zeros(imsize,imsize);
claypn = zeros(imsize,imsize);
claynn = zeros(imsize,imsize);

for f = 1:numel(folders)
%% Calculate defects for current experiment and exclude ones that have charge of 0, or are in holes.
    fpath = folders{f};
    ts = getts(fpath);
    
    load([fpath 'adefs.mat'],'adefs');
    
    x = [adefs.x];
    y = [adefs.y];
    dt = [adefs.d];
    d = [dt(1:2:end-1)' dt(2:2:end)'];
    q = [adefs.q];
    tt = [adefs.tt];
    ts = [adefs.ts];
    id = [adefs.id];

    
    N = numel(ts);
    
    %% Go through all defects and find the layer count around it.
        
    for i = 1:numel(x)

        t = ts(i);
        lays = loaddata(fpath,t,'manuallayers','int8');
        
        lays = padarray(lays,[imsize,imsize],NaN,'both');

        clays = lays(round(y(i)):round(y(i)+(2*imsize)),...
            round(x(i)):round(x(i)+2*imsize));

        clays1 = imrotate(clays,atan2d(d(i,2),d(i,1)),'nearest','crop');
        clays1 = clays1((imsize+1)/2+1:end-(imsize+1)/2,...
            (imsize+1)/2+1:end-(imsize+1)/2);
        %clays1 = clays1 - clays1((imsize-1)/2,(imsize-1)/2);
        
        clays2 = imrotate(clays,120 + atan2d(d(i,2),d(i,1)),'nearest','crop');
        clays2 = clays2((imsize+1)/2+1:end-(imsize+1)/2,...
            (imsize+1)/2+1:end-(imsize+1)/2);
        %clays2 = clays2 - clays2((imsize-1)/2,(imsize-1)/2);
        
        clays3 = imrotate(clays,240 + atan2d(d(i,2),d(i,1)),'nearest','crop');
        clays3 = clays3((imsize+1)/2+1:end-(imsize+1)/2,...
            (imsize+1)/2+1:end-(imsize+1)/2);
        %clays3 = clays3 - clays3((imsize-1)/2,(imsize-1)/2);

        clays4 = flipud(clays1);
        clays5 = flipud(clays2);
        clays6 = flipud(clays3);
        
        
        count1 = ~isnan(clays1);
        count2 = ~isnan(clays2);
        count3 = ~isnan(clays3);
        count4 = ~isnan(clays4);
        count5 = ~isnan(clays5);
        count6 = ~isnan(clays6);
        clays1(isnan(clays1)) = 0;
        clays2(isnan(clays2)) = 0;
        clays3(isnan(clays3)) = 0;
        clays4(isnan(clays4)) = 0;
        clays5(isnan(clays5)) = 0;
        clays6(isnan(clays6)) = 0;
            
        if q(i)>0
            clayp = clayp + clays1;
            claypn = claypn + count1;
            clayp = clayp + clays4;
            claypn = claypn + count4;
        elseif q(i)<0 
            clayn = clayn + clays1;
            claynn = claynn + count1;
            clayn = clayn + clays2;
            claynn = claynn + count2;
            clayn = clayn + clays3;
            claynn = claynn + count3;
            clayn = clayn + clays4;
            claynn = claynn + count4;
            clayn = clayn + clays5;
            claynn = claynn + count5;
            clayn = clayn + clays6;
            claynn = claynn + count6;
        end
    end
end

%% Plot em
figure('Units','pixels','Position',[200 200 480 720]);
thetas = -pi:pi/20:pi;

axes('Units','pixels','Position',[40 380 300 300])
x = 1:imsize;
y = 1:imsize;
[xx,yy] = meshgrid(x,y);
rr = sqrt((xx-(imsize-1)/2).^2+(yy-(imsize-1)/2).^2);

im = real2rgb(clayp./claypn,myxocmap);


img = image(im);
hold on
axis off
axis equal
img.AlphaData = rr<(imsize-1)/2;
hold on
clayp(rr>((imsize-1)/2)) = -1;
contour(clayp./claypn,[-1 0 1],'Color','k','LineWidth',2);
plot((imsize-1)/2*cos(thetas)+(imsize-1)/2,(imsize-1)/2*sin(thetas)...
    +(imsize-1)/2,'k','LineWidth',2);
dl = 20;
ds = 30;
plot([(imsize-1)/2-1 (imsize-1)/2-1+dl+1],[(imsize-1)/2 (imsize-1)/2], 'k','LineWidth',5);
plot((imsize-1)/2,(imsize-1)/2, 'k.','MarkerSize',ds+7)
plot([(imsize-1)/2 (imsize-1)/2-1+dl],[(imsize-1)/2 (imsize-1)/2], 'w','LineWidth',3);
plot((imsize-1)/2,(imsize-1)/2, 'w.','MarkerSize',ds)



im = real2rgb(clayn./claynn,myxocmap);

axes('Units','pixels','Position',[40 40 300 300]);
img = image(im);
axis equal
axis off
img.AlphaData = rr<(imsize-1)/2;
hold on

clayn(rr>((imsize-1)/2)) = -1;
contour(clayn./claynn,[-1 0 1],'Color','k','LineWidth',2);
plot((imsize-1)/2*cos(thetas)+(imsize-1)/2,(imsize-1)/2*sin(thetas)...
    +(imsize-1)/2,'k','LineWidth',2);
plot((imsize-1)/2,(imsize-1)/2,'k.','MarkerSize',ds+7);
plot([(imsize-1)/2 (imsize-1)/2+(dl+1)*cos(0)],[(imsize-1)/2 (imsize-1)/2+(dl+1)*sin(0)],'k','LineWidth',5);
plot([(imsize-1)/2 (imsize-1)/2+(dl+1)*cos(2*pi/3)],[(imsize-1)/2 (imsize-1)/2+(dl+1)*sin(2*pi/3)],'k','LineWidth',5);
plot([(imsize-1)/2 (imsize-1)/2+(dl+1)*cos(4*pi/3)],[(imsize-1)/2 (imsize-1)/2+(dl+1)*sin(4*pi/3)],'k','LineWidth',5);

plot((imsize-1)/2,(imsize-1)/2,'w.','MarkerSize',ds);
plot([(imsize-1)/2 (imsize-1)/2+dl*cos(0)],[(imsize-1)/2 (imsize-1)/2+dl*sin(0)],'w','LineWidth',3);
plot([(imsize-1)/2 (imsize-1)/2+dl*cos(2*pi/3)],[(imsize-1)/2 (imsize-1)/2+dl*sin(2*pi/3)],'w','LineWidth',3);
plot([(imsize-1)/2 (imsize-1)/2+dl*cos(4*pi/3)],[(imsize-1)/2 (imsize-1)/2+dl*sin(4*pi/3)],'w','LineWidth',3);

axes('Units','pixels','Position',[360 400 15 260]);
cbarx = 1:15;
cbary = 1:260;
[~,cbarim] = meshgrid(cbarx,cbary);

im = real2rgb(cbarim,myxocmap);
image(im);
axis off
set(gca,'YDir','normal');
text(18,0,sprintf('%1.2f',min(min(clayp./claypn))),'FontSize',14);
text(18,260,sprintf('%1.2f',max(max(clayp./claypn))),'FontSize',14);
text(18,130,sprintf('%1.2f',(max(max(clayp./claypn))+min(min(clayp./claypn)))/2),'FontSize',14);

axes('Units','pixels','Position',[360 60 15 260],'YDir','normal');
image(im);
axis off
set(gca,'YDir','normal');
text(18,0,sprintf('%1.2f',min(min(clayn./claynn))),'FontSize',14);
text(18,260,sprintf('%1.2f',max(max(clayn./claynn))),'FontSize',14);
text(18,130,sprintf('%1.2f',(max(max(clayn./claynn))+min(min(clayn./claynn)))/2),'FontSize',14);

