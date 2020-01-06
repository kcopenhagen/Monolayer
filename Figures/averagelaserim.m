function averagelaserim(datapath)
addpath('../Director field');
imsize = 401;
folders = dir(datapath);
dirFlags = [folders.isdir];
folders = folders(dirFlags);
folders(1:2) = [];

clayp = zeros(imsize,imsize);
clayn = zeros(imsize,imsize);
claypn = zeros(imsize,imsize);
claynn = zeros(imsize,imsize);

for f = 1:numel(folders)
%% Calculate defects for current experiment and exclude ones that have charge of 0, or are in holes.

    fpath = [folders(f).folder '/' folders(f).name '/'];
    files = dir([fpath 'Laser/']);
    dirFlags = [files.isdir];
    files = files(~dirFlags);
    
    load([fpath 'adefs.mat'],'adefs');
    
    x = [adefs.x];
    y = [adefs.y];
    dt = [adefs.d];
    d = [dt(1:2:end-1)' dt(2:2:end)'];
    q = [adefs.q];
    tt = [adefs.tt];
    ts = [adefs.ts];
    id = [adefs.id];

    
    N = numel(files);
    
    %% Go through all defects and find the layer count around it.
        
    for i = 1:numel(x)

        t = ts(i);
        %lays = loaddata(fpath,t,'manuallayers','int8');
        l = laserdata(fpath,t);
        l = l./imgaussfilt(l,64);
        l = padarray(l,[imsize,imsize],NaN,'both');

        clays = l(round(y(i)):round(y(i)+(2*imsize)),...
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
fig = figure('Units','pixels','Position',[200 200 560 560]);

ax = axes('Units','pixels','Position',[140 140 400 400],'FontSize', 34,...
    'Visible','on','FontName', 'Latin Modern Math','layer','top','box','on',...
    'TickLength',[0.03 0.03],'LineWidth',1);

hold(ax,'on')
axis on
avgl = clayp./claypn;
avglp = imgaussfilt(avgl,13);
surf(avglp,'EdgeColor','none');
colormap gray
xticks(201-20/0.133:10/0.133:201+20/0.133)
yticks(201-20/0.133:10/0.133:201+20/0.133)
yticklabels(["-20   " "-10   " "0   " "10   " "20   "]);
xticklabels(-20:10:20)
xlim([201-20/0.133 201+20/0.133])
ylim([201-20/0.133 201+20/0.133])
ylabel('$y ({\mu}$m$)$','Interpreter','latex')
xlabel('$x ({\mu}$m$)$','Interpreter','latex','Position',[201 -15 1])

fig = figure('Units','pixels','Position',[200 200 560 560]);


ax2 = axes('Units','pixels','Position',[140 140 400 400],'FontSize', 34,...
    'Visible','on','FontName', 'Latin Modern Math','layer','top','box','on',...
    'TickLength',[0.03 0.03],'LineWidth',1);
hold(ax2,'on')
avgl = clayn./claynn;
avgln = imgaussfilt(avgl,13);
surf(avgln,'EdgeColor','none');
colormap(gray)
xticks(201-20/0.133:10/0.133:201+20/0.133)
yticks(201-20/0.133:10/0.133:201+20/0.133)
xticklabels(-20:10:20)
yticklabels(-20:10:20)
xlim([201-20/0.133 201+20/0.133])
ylim([201-20/0.133 201+20/0.133])
ylabel('$y ({\mu}$m$)$','Interpreter','latex')
xlabel('$x ({\mu}$m$)$','Interpreter','latex','Position',[201 -15 1])


