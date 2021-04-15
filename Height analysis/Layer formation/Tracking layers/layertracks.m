
lay2pdefs = [];
lay2ndefs = [];
hole2pdefs = [];
hole2ndefs = [];
fpaths = getfold(datapath);

for f = 1:numel(fpaths)


lay2 = [];
hole = [];

fpath = fpaths{f};
ts = getts(fpath);

for t = 1:numel(ts)
    %% Identifying layers and holes for tracking.

    lays = loaddata(fpath,t,'covid_layers','int8');

    layers = lays==2;

    CC = bwconncomp((layers));
    P = regionprops(CC,'PixelIdxList','Area','Centroid');
    for j = 1:numel(P)
        lay2(end+1).PixList = P(j).PixelIdxList;
        lay2(end).Cent = P(j).Centroid;
        lay2(end).Area = P(j).Area;
        lay2(end).t = t;
        lay2(end).id = -1;
        
    end
    
    holes = lays==0;

    CC = bwconncomp((holes));
    P = regionprops(CC,'PixelIdxList','Area','Centroid');
    for j = 1:numel(P)
        hole(end+1).PixList = P(j).PixelIdxList;
        hole(end).Cent = P(j).Centroid;
        hole(end).Area = P(j).Area;
        hole(end).t = t;
        hole(end).id = -1;
        
    end
end

%% Track layers
if ~isempty(lay2)
    i = find([lay2.id]==-1,1);
    clab = 1;

    while sum([lay2.id]==-1)>0
        lay2(i).id = clab;
        js = find([lay2.t] == lay2(i).t+1);

        ni = [];

        for j = js
            if intersect([lay2(j).PixList],[lay2(i).PixList])
                ni = [ni; j];
            end
        end

        if numel(ni) == 1
            js2 = find([lay2.t] == lay2(i).t);
            ni2 = [];
            for j2 = js2
                if intersect([lay2(j2).PixList],[lay2(ni).PixList])
                    ni2 = [ni2; j2];
                end
            end

            if numel(ni2) == 1 && abs((0.133)^2*numel([lay2(ni).PixList])-(0.133)^2*numel([lay2(ni2).PixList]))<100
                i = ni;
            else
                i = find([lay2.id]==-1,1);
                clab = clab+1;
            end
        else
            i = find([lay2.id]==-1,1);
            clab = clab+1;
        end
    end
end
%% Track holes
if ~isempty(hole)
    i = find([hole.id]==-1,1);
    clab = 1;

    while sum([hole.id]==-1)>0
        hole(i).id = clab;
        js = find([hole.t] == hole(i).t+1);

        ni = [];

        for j = js
            if intersect([hole(j).PixList],[hole(i).PixList])
                ni = [ni; j];
            end
        end

        if numel(ni) == 1
            js2 = find([hole.t] == hole(i).t);
            ni2 = [];
            for j2 = js2
                if intersect([hole(j2).PixList],[hole(ni).PixList])
                    ni2 = [ni2; j2];
                end
            end

            if numel(ni2) == 1 && abs((0.133)^2*numel([hole(ni).PixList])-(0.133)^2*numel([hole(ni2).PixList]))<100
                i = ni;
            else
                i = find([hole.id]==-1,1);
                clab = clab+1;
            end
        else
            i = find([hole.id]==-1,1);
            clab = clab+1;
        end
    end
end
%% Source for each layer formation.
if ~isempty(lay2)
    edges = zeros(size(lays));
    edges(:,1:15) = 1;
    edges(1:15,:) = 1;
    edges(:,end-14:end) = 1;
    edges(end-14:end,:) = 1;
    edidxs = find(edges);

    ids = unique([lay2.id]);

    lay2props = [];

    for i = 1:numel(ids)
        clay = lay2([lay2.id]==ids(i));
        play = lay2([lay2.t]==clay(1).t-1);

        lay2props(ids(i)).source = -1;
        lay2props(ids(i)).id = ids(i);

        if max([clay.Area])*(0.133)^2<1
            lay2props(ids(i)).source = 'Other';
        end
        if min([clay.t]) == 1
            lay2props(ids(i)).source = 'Started';
        end
        if ismember([clay(1).PixList],edidxs)
            lay2props(ids(i)).source = 'Edge';
        end
        if sum(ismember([clay(1).PixList],vertcat(play.PixList)))>1
            lay2props(ids(i)).source = 'Split';
        end
    end


    for i = 1:numel(ids)

        if lay2props(ids(i)).source == -1
            cnewlay = find([lay2.id]==ids(i));
            UIfig = setsource(fpath,lay2(min(cnewlay)).t,...
                lay2(min(cnewlay)).Cent(1),lay2(min(cnewlay)).Cent(2));
            uiwait(UIfig.UIFigure);

            list = {'Started','Emerged','Split','Edge','Other'};
            out = listdlg('ListString',list,'SelectionMode','single',...
                'ListSize',[160 60]);
            lay2props(ids(i)).source = list{out};
            keyboard
        end

    end
end
%% Source for each hole formation.
if ~isempty(hole)
    edges = zeros(size(lays));
    edges(:,1:15) = 1;
    edges(1:15,:) = 1;
    edges(:,end-14:end) = 1;
    edges(end-14:end,:) = 1;
    edidxs = find(edges);

    ids = unique([hole.id]);

    holeprops = [];

    for i = 1:numel(ids)
        chole = hole([hole.id]==ids(i));
        phole = hole([hole.t]==chole(1).t-1);

        holeprops(ids(i)).source = -1;
        holeprops(ids(i)).id = ids(i);

        if max([chole.Area])*(0.133)^2<1
            holeprops(ids(i)).source = 'Other';
        end
        if min([chole.t]) == 1
            holeprops(ids(i)).source = 'Started';
        end
        if ismember([chole(1).PixList],edidxs)
            holeprops(ids(i)).source = 'Edge';
        end
        if sum(ismember([chole(1).PixList],vertcat(phole.PixList)))>1
            holeprops(ids(i)).source = 'Split';
        end
    end


    for i = 1:numel(ids)

        if holeprops(ids(i)).source == -1
            cnewhole = find([hole.id]==ids(i));
            UIfig = setsource(fpath,hole(min(cnewhole)).t,...
                hole(min(cnewhole)).Cent(1),hole(min(cnewhole)).Cent(2));
            uiwait(UIfig.UIFigure);

            list = {'Started','Emerged','Split','Edge','Other'};
            out = listdlg('ListString',list,'SelectionMode','single',...
                'ListSize',[160 60]);
            holeprops(ids(i)).source = list{out};
            keyboard
        end

    end


end
%% Distance layers to defects.
if ~isempty(lay2)
    newlayer = [];
    for i = 1:numel(lay2props)
        if lay2props(i).source == "Emerged"
            clay = lay2([lay2.id]==lay2props(i).id);
            newlayer = [newlayer; clay(1)];

        end
    end

    load([fpath 'adefs.mat'],'adefs');

    for i = 1:numel(newlayer)
        cdefs = adefs([adefs.ts] == newlayer(i).t);
        pdefs = cdefs([cdefs.q]>0);
        ndefs = cdefs([cdefs.q]<0);
        [layy,layx] = ind2sub(size(lays),newlayer(i).PixList);
        pds = [];
        for j = 1:numel(pdefs)
            pdxs = pdefs(j).x-layx;
            pdys = pdefs(j).y-layy;
            pdrs = sqrt(pdxs.^2+pdys.^2);
            pds  = [pds; min(pdrs(:))];
        end
        nds = [];
        for j = 1:numel(ndefs)
            ndxs = [ndefs(j).x]-layx;
            ndys = [ndefs(j).y]-layy;
            ndrs = sqrt(ndxs.^2+ndys.^2);
            nds = [nds; min(ndrs(:))];
        end
        newlayer(i).pd = pds;
        newlayer(i).nd = nds;
    end
end
%% Distance holes to defects.
if ~isempty(hole)
    newhole = [];
    for i = 1:numel(holeprops)
        if holeprops(i).source == "Emerged"
            chole = hole([hole.id]==holeprops(i).id);
            newhole = [newhole; chole(1)];

        end
    end

    load([fpath 'adefs.mat'],'adefs');

    for i = 1:numel(newhole)
        cdefs = adefs([adefs.ts] == newhole(i).t);
        pdefs = cdefs([cdefs.q]>0);
        ndefs = cdefs([cdefs.q]<0);
        [holey,holex] = ind2sub(size(lays),newhole(i).PixList);
        pds = [];
        for j = 1:numel(pdefs)
            pdxs = pdefs(j).x-holex;
            pdys = pdefs(j).y-holey;
            pdrs = sqrt(pdxs.^2+pdys.^2);
            pds  = [pds; min(pdrs(:))];
        end
        nds = [];
        for j = 1:numel(ndefs)
            ndxs = [ndefs(j).x]-holex;
            ndys = [ndefs(j).y]-holey;
            ndrs = sqrt(ndxs.^2+ndys.^2);
            nds = [nds; min(ndrs(:))];
        end
        newhole(i).pd = pds;
        newhole(i).nd = nds;
    end
end
%%
try
lay2pdefs = [lay2pdefs; vertcat(newlayer.pd)];
end
try
lay2ndefs = [lay2ndefs; vertcat(newlayer.nd)];
end
try
hole2pdefs = [hole2pdefs; vertcat(newhole.pd)];
end
try
hole2ndefs = [hole2ndefs; vertcat(newhole.nd)];
end

end

lay2pdefs = 0.133*lay2pdefs;
lay2ndefs = 0.133*lay2ndefs;
hole2pdefs = 0.133*hole2pdefs;
hole2ndefs = 0.133*hole2ndefs;

%% Null model
fweights = [];
ats = [];
afs = [];
for f = 1:numel(fpaths)
    ts = getts(fpaths{f});
    ats = [ats; (1:numel(ts))'];
    afs = [afs; f*ones(size(ts))];
    
end
testis = randi(numel(afs),10000,1);

cpds = [];
cnds = [];

for i = 1:numel(testis)
    testi = testis(i);
    
    fpath = fpaths{afs(testi)};
    t = ats(testi);
    
    load([fpath 'adefs.mat'],'adefs');
    cdefs = adefs([adefs.ts] == t);
    pdefs = cdefs([cdefs.q]>0);
    ndefs = cdefs([cdefs.q]<0);
    
    testx = randi(994)+15;
    testy = randi(738)+15;
    
    pdxs = [pdefs.x]-testx;
    pdys = [pdefs.y]-testy;
    pds = sqrt(pdxs.^2+pdys.^2);
    
    ndxs = [ndefs.x]-testx;
    ndys = [ndefs.y]-testy;
    nds = sqrt(ndxs.^2+ndys.^2);
    
    cpds = [cpds; pds'];
    cnds = [cnds; nds'];
end

cpds = 0.133*cpds;
cnds = 0.133*cnds;


%% Plots

fig = figure('Units','pixels','Position',[440 378 560 540]);
ax = axes(fig,'Units','pixels','Position',[135 345 305 180],...
    'FontSize', 24,...
    'Visible','on','FontName', 'Latin Modern Math','layer','top','box','on',...
    'TickLength',[0.03 0.03],'LineWidth',2,'YScale','log');

hold(ax,'on');
hold on

pcol = [230 31 15]/255;
ncol = [0 115 178]/255;
% pws = 0.0001:1:10;
% eds = 0.133*[0 2.^pws];
eds = [0 0.6 2 4 8 14 22 32];
eds2 = eds(2:end);
eds1 = eds(1:end-1);
xs = (eds2+eds1)/2;
r = xs;
dr = (eds2 - eds1);

cpdcs = histcounts(cpds,eds,'Normalization','probability');
cndcs = histcounts(cnds,eds,'Normalization','probability');

% cpdcserr = cpdcs.*(1-cpdcs)/numel(cpds);
% cndcserr = cndcs.*(1-cndcs)/numel(cnds);

cpdcserr = sqrt(cpdcs./(numel(cpds)*(dr)));
cndcserr = sqrt(cndcs./(numel(cnds)*(dr)));

lpdcs = histcounts(lay2pdefs,eds,'Normalization','probability');
lndcs = histcounts(lay2ndefs,eds,'Normalization','probability');
% 
% lpdcserr = lpdcs.*(1-lpdcs)/numel(lay2pdefs);
% lndcserr = lndcs.*(1-lndcs)/numel(lay2ndefs);

lpdcserr = sqrt(lpdcs./(numel(lay2pdefs)*dr));
lndcserr = sqrt(lndcs./(numel(lay2ndefs)*dr));

hpdcs = histcounts(hole2pdefs,eds,'Normalization','probability');
hndcs = histcounts(hole2ndefs,eds,'Normalization','probability');
% 
% hpdcserr = hpdcs.*(1-hpdcs)/numel(hole2pdefs);
% hndcserr = hndcs.*(1-hndcs)/numel(hole2ndefs);
% 

hpdcserr = sqrt(hpdcs./(numel(hole2pdefs)*dr));
hndcserr = sqrt(hndcs./(numel(hole2ndefs)*dr));

lpderr = lpdcs./cpdcs.*sqrt((lpdcserr./lpdcs).^2+(cpdcserr./cpdcs).^2);
lnderr = lndcs./cndcs.*sqrt((lndcserr./lndcs).^2+(cndcserr./cndcs).^2);

hpderr = hpdcs./cpdcs.*sqrt((hpdcserr./hpdcs).^2+(cpdcserr./cpdcs).^2);
hnderr = hndcs./cndcs.*sqrt((hndcserr./hndcs).^2+(cndcserr./cndcs).^2);

errorbar(xs,lpdcs./cpdcs,lpderr,'.','Color',pcol,'LineWidth',3,'MarkerSize',20)
hold on
errorbar(xs,lndcs./cndcs,lnderr,'.','Color',ncol,'LineWidth',3,'MarkerSize',20)
ylim([0.5 1000])
xticks([0 5 10 15 20])
xlim([0 20])

xticklabels([]);
yticklabels([]);
Yrule = get(ax,'YRuler');
Yrule.MinorTickValues = [0.1:0.1:0.9 1:9 10:10:90 100:100:1000];


ax2 = axes(fig,'Units','pixels','Position',[135 135 305 180],...
    'FontSize', 24,...
    'Visible','on','FontName', 'Latin Modern Math','layer','top','box','on',...
    'TickLength',[0.03 0.03],'LineWidth',2,'YScale','log');
hold(ax2,'on');

errorbar(xs,hndcs./cndcs,hnderr,'.','Color',ncol,'LineWidth',3,'MarkerSize',20)
hold on
errorbar(xs,hpdcs./cpdcs,hpderr,'.','Color',pcol,'LineWidth',3,'MarkerSize',20)

xticks([0 5 10 15 20])
xlim([0 20])
ylim([0.5 1000])
xticklabels([])
yticklabels([])
Yrule = get(ax2,'YRuler');
Yrule.MinorTickValues = [0.1:0.1:0.9 1:9 10:10:90 100:100:1000];
plot(ax2,0.133*[0 400],[1 1],'k-.','LineWidth',2)
plot(ax,0.133*[0 400],[1 1],'k-.','LineWidth',2)


%% Standard Normalization


fig = figure('Units','pixels','Position',[440 378 560 540]);
ax = axes(fig,'Units','pixels','Position',[135 345 305 180],...
    'FontSize', 24,...
    'Visible','on','FontName', 'Latin Modern Math','layer','top','box','on',...
    'TickLength',[0.03 0.03],'LineWidth',2,'YScale','log');

hold(ax,'on');
hold on

pcol = [230 31 15]/255;
ncol = [0 115 178]/255;
% 
% pws = 2:10;
% eds = 0.133*[0 2.^pws];
% eds2 = eds(2:end);
% eds1 = eds(1:end-1);
% xs = (eds2+eds1)/2;


r = xs;
dr = (eds2 - eds1);
rho = (3168/1863)/((1024*768*0.133^2));
rho = 1/((1024*768*0.133^2));


lpdcs = histcounts(lay2pdefs,eds,'Normalization','probability');
lndcs = histcounts(lay2ndefs,eds,'Normalization','probability');

hpdcs = histcounts(hole2pdefs,eds,'Normalization','probability');
hndcs = histcounts(hole2ndefs,eds,'Normalization','probability');

errorbar(xs,lpdcs./(2*pi*xs.*dr*rho),lpdcserr./(2*pi*xs.*dr*rho),'.','Color',pcol,'LineWidth',3,'MarkerSize',20)
hold on
errorbar(xs,lndcs./(2*pi*xs.*dr*rho),lndcserr./(2*pi*xs.*dr*rho),'.','Color',ncol,'LineWidth',3,'MarkerSize',20)
ylim([0.5 1000])
xticks([0 5 10 15 20])
xlim([0 20])
xticklabels([]);
yticklabels([]);
Yrule = get(ax,'YRuler');
Yrule.MinorTickValues = [0.1:0.1:0.9 1:9 10:10:90 100:100:1000];


ax2 = axes(fig,'Units','pixels','Position',[135 135 305 180],...
    'FontSize', 24,...
    'Visible','on','FontName', 'Latin Modern Math','layer','top','box','on',...
    'TickLength',[0.03 0.03],'LineWidth',2,'YScale','log');
hold(ax2,'on');


errorbar(xs,hndcs./(2*pi*xs.*dr*rho),hndcserr./(2*pi*xs.*dr*rho),'.',...
    'Color',ncol,'LineWidth',3,'MarkerSize',20)
hold on
errorbar(xs,hpdcs./(2*pi*xs.*dr*rho),hpdcserr./(2*pi*xs.*dr*rho),'.',...
    'Color',pcol,'LineWidth',3,'MarkerSize',20)
xticks([0 5 10 15 20])
xlim([0 20])
ylim([0.5 1000])
xticklabels([])
yticklabels([])
Yrule = get(ax2,'YRuler');
Yrule.MinorTickValues = [0.1:0.1:0.9 1:9 10:10:90 100:100:1000];

plot(ax2,0.133*[0 400],[1 1],'k-.','LineWidth',2)
plot(ax,0.133*[0 400],[1 1],'k-.','LineWidth',2)


%% Plots linear bins

fig = figure('Units','pixels','Position',[440 378 560 540]);
ax = axes(fig,'Units','pixels','Position',[135 345 305 180],...
    'FontSize', 24,...
    'Visible','on','FontName', 'Latin Modern Math','layer','top','box','on',...
    'TickLength',[0.03 0.03],'LineWidth',2,'YScale','log');

hold(ax,'on');
hold on

pcol = [230 31 15]/255;
ncol = [0 115 178]/255;
% pws = 2:1:10;
% eds = 0.133*[0 2.^pws];
eds = 0:2:50;
eds2 = eds(2:end);
eds1 = eds(1:end-1);
xs = (eds2+eds1)/2;
r = xs;
dr = (eds2 - eds1);

cpdcs = histcounts(cpds,eds,'Normalization','probability');
cndcs = histcounts(cnds,eds,'Normalization','probability');

% cpdcserr = cpdcs.*(1-cpdcs)/numel(cpds);
% cndcserr = cndcs.*(1-cndcs)/numel(cnds);

cpdcserr = sqrt(cpdcs./(numel(cpds)*(dr)));
cndcserr = sqrt(cndcs./(numel(cnds)*(dr)));

lpdcs = histcounts(lay2pdefs,eds,'Normalization','probability');
lndcs = histcounts(lay2ndefs,eds,'Normalization','probability');
% 
% lpdcserr = lpdcs.*(1-lpdcs)/numel(lay2pdefs);
% lndcserr = lndcs.*(1-lndcs)/numel(lay2ndefs);

lpdcserr = sqrt(lpdcs./(numel(lay2pdefs)*dr));
lndcserr = sqrt(lndcs./(numel(lay2ndefs)*dr));

hpdcs = histcounts(hole2pdefs,eds,'Normalization','probability');
hndcs = histcounts(hole2ndefs,eds,'Normalization','probability');
% 
% hpdcserr = hpdcs.*(1-hpdcs)/numel(hole2pdefs);
% hndcserr = hndcs.*(1-hndcs)/numel(hole2ndefs);
% 

hpdcserr = sqrt(hpdcs./(numel(hole2pdefs)*dr));
hndcserr = sqrt(hndcs./(numel(hole2ndefs)*dr));

lpderr = lpdcs./cpdcs.*sqrt((lpdcserr./lpdcs).^2+(cpdcserr./cpdcs).^2);
lnderr = lndcs./cndcs.*sqrt((lndcserr./lndcs).^2+(cndcserr./cndcs).^2);

hpderr = hpdcs./cpdcs.*sqrt((hpdcserr./hpdcs).^2+(cpdcserr./cpdcs).^2);
hnderr = hndcs./cndcs.*sqrt((hndcserr./hndcs).^2+(cndcserr./cndcs).^2);

errorbar(xs,lpdcs./cpdcs,lpderr,'Color',pcol,'LineWidth',3)
hold on
errorbar(xs,lndcs./cndcs,lnderr,'Color',ncol,'LineWidth',3)
ylim([0.5 1000])
xticks([0 5 10 15 20])
xlim([0 20])

xticklabels([]);
yticklabels([]);
Yrule = get(ax,'YRuler');
Yrule.MinorTickValues = [0.1:0.1:0.9 1:9 10:10:90 100:100:1000];


ax2 = axes(fig,'Units','pixels','Position',[135 135 305 180],...
    'FontSize', 24,...
    'Visible','on','FontName', 'Latin Modern Math','layer','top','box','on',...
    'TickLength',[0.03 0.03],'LineWidth',2,'YScale','log');
hold(ax2,'on');

errorbar(xs,hpdcs./cpdcs,hpderr,'Color',pcol,'LineWidth',3)
hold on
errorbar(xs,hndcs./cndcs,hnderr,'Color',ncol,'LineWidth',3)
xticks([0 5 10 15 20])
xlim([0 20])
ylim([0.5 1000])
xticklabels([])
yticklabels([])
Yrule = get(ax2,'YRuler');
Yrule.MinorTickValues = [0.1:0.1:0.9 1:9 10:10:90 100:100:1000];
plot(ax2,0.133*[0 400],[1 1],'k-.','LineWidth',2)
plot(ax,0.133*[0 400],[1 1],'k-.','LineWidth',2)


%% Standard Normalization


fig = figure('Units','pixels','Position',[440 378 560 540]);
ax = axes(fig,'Units','pixels','Position',[135 345 305 180],...
    'FontSize', 24,...
    'Visible','on','FontName', 'Latin Modern Math','layer','top','box','on',...
    'TickLength',[0.03 0.03],'LineWidth',2,'YScale','log');

hold(ax,'on');
hold on

pcol = [230 31 15]/255;
ncol = [0 115 178]/255;

pws = 2:10;
eds = 0:2:50;
eds2 = eds(2:end);
eds1 = eds(1:end-1);
xs = (eds2+eds1)/2;


r = xs;
dr = (eds2 - eds1);
rho = (3168/1863)/((1024*768*0.133^2));
rho = 1/((1024*768*0.133^2));


lpdcs = histcounts(lay2pdefs,eds,'Normalization','probability');
lndcs = histcounts(lay2ndefs,eds,'Normalization','probability');

hpdcs = histcounts(hole2pdefs,eds,'Normalization','probability');
hndcs = histcounts(hole2ndefs,eds,'Normalization','probability');

errorbar(xs,lpdcs./(2*pi*xs.*dr*rho),lpdcserr./(2*pi*xs.*dr*rho),'Color',pcol,'LineWidth',3)
hold on
errorbar(xs,lndcs./(2*pi*xs.*dr*rho),lndcserr./(2*pi*xs.*dr*rho),'Color',ncol,'LineWidth',3)
ylim([0.5 1000])
xticks([0 5 10 15 20])
xlim([0 20])
xticklabels([]);
yticklabels([]);
Yrule = get(ax,'YRuler');
Yrule.MinorTickValues = [0.1:0.1:0.9 1:9 10:10:100];


ax2 = axes(fig,'Units','pixels','Position',[135 135 305 180],...
    'FontSize', 24,...
    'Visible','on','FontName', 'Latin Modern Math','layer','top','box','on',...
    'TickLength',[0.03 0.03],'LineWidth',2,'YScale','log');
hold(ax2,'on');

errorbar(xs,hpdcs./(2*pi*xs.*dr*rho),hpdcserr./(2*pi*xs.*dr*rho),'Color',pcol,'LineWidth',3)
hold on
errorbar(xs,hndcs./(2*pi*xs.*dr*rho),hndcserr./(2*pi*xs.*dr*rho),'Color',ncol,'LineWidth',3)
xticks([0 5 10 15 20])
xlim([0 20])
ylim([0.5 1000])
xticklabels([])
yticklabels([])
Yrule = get(ax2,'YRuler');
Yrule.MinorTickValues = [0.1:0.1:0.9 1:9 10:10:100];

plot(ax2,0.133*[0 400],[1 1],'k-.','LineWidth',2)
plot(ax,0.133*[0 400],[1 1],'k-.','LineWidth',2)
