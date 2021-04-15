fpaths = getfold(datapath);
qs = [];
areas = [];
holes = [];
for f = 1:numel(fpaths)
    fpath = fpaths{f};
    ts = getts(fpath);
    for t = 1:numel(ts)
        dfield = loaddata(fpath,t,'dfield','float');
        
        lays = loaddata(fpath,t,'manuallayers','int8');
        lays = round(imgaussfilt(lays,3));
        holesim = lays==0;
        
        holesim = imclearborder(holesim);
        
        CC = bwconncomp(holesim);
        
        P = regionprops(CC,'Area','PixelIdxList');
        for i = 1:numel(P)
            holes(end+1).q = regioncharge(P(i),dfield);
            holes(end).area = P(i).Area;
            holes(end).id = -1;
            holes(end).branch = -1;
            holes(end).fpath = fpath;
            holes(end).t = t;
            holes(end).pix = P(i).PixelIdxList;
            
        end
    end
end

%% Track holes.

id = 1;

i = find([holes.id]==-1,1);
tic
while ~isempty(i)
    et = toc;
    fprintf("Completed: %f, Time elapsed: %f mins\n",sum([holes.id]>0)/numel(holes),et/60)
    [id, holes] = labelhole(i,id,holes);
    i = find([holes.id]==-1,1);
    id = find(~ismember(1:numel(holes),[holes.id]),1);
end

%% Find closest defect to each hole.

for id = unique([holes.id])
    choles = [holes.id]==id;
    mint = min([holes(choles).t]);
    
    load([holes(find(choles,1)).fpath 'adefs.mat'],'adefs');
    fhole = holes(find(choles,1));
    cdefs = adefs([adefs.ts]==mint-1);
    cdefs = cdefs([cdefs.q]<0);
    [I, J] = ind2sub(size(l),fhole.pix);
    holex = mean(J);
    holey = mean(I);
    dists = sqrt((holex-[cdefs.x]).^2+(holey-[cdefs.y]).^2);
    mind = min(dists);
    holes(find(choles,1)).mind = mind;
end

%%
cols = rand(numel(unique([holes.id])),3);

%%
fig = figure;
ax = axes(fig);
set(ax,'FontSize',24,'XLim', [0 538], 'YLim', [0 600]);
qcol = [0.5 1 1; 0 1 1; 0 0 1; 0 0 0; 1 0 0; 1 1 0; 1 1 0.5];
n = 0;
for id = unique([holes.id])
    chole = holes([holes.id]==id);
    if numel(chole)>10
        cla(ax);
        scatter([chole.t]',(0.133^2)*[chole.area]',2,qcol([chole.q]'*2+4,:));
        hold on
        text(mean([chole.t]),max((0.133^2)*[chole.area]')+20,...
            sprintf('%2.2f microns',chole(1).mind*0.133),'Color',cols(id,:),'FontSize',16);
        xlim([0 538])
        ylim([0 600])
        keyboard
        n = n+1;
    end
end

%% Plot lines together
fig = figure;
ax = axes(fig);
set(ax,'FontSize',24,'XLim', [0 538], 'YLim', [0 600]);


for id = sids
    chole = holes([holes.id]==id);
    scatter(mean([chole.t]'),mean((0.133^2)*[chole.area]'),80,cols(id,:),'filled');
    hold on
end
for id = sids
    chole = holes([holes.id]==id);
    if numel(chole)>10
        scatter([chole.t]',(0.133^2)*[chole.area]',2,qcol([chole.q]'*2+4,:));
        hold on
        xlim([0 538])
        ylim([0 600])

    end
end
set(ax,'FontSize',24,'XLim', [0 538], 'YLim', [0 600],'LineWidth',2);

%%
fpaths = getfold(datapath);
vids = [];
for f = 1:numel(fpaths)
    fpath = fpaths{f};
    inex = arrayfun(@(x)eq(string(fpath),string(x.fpath)),holes);
    exholes = holes(inex);
    
    for i = 1:numel(exholes)
        l = laserdata(exholes(i).fpath,exholes(i).t);
        l = l./imgaussfilt(l,64);
        l = normalise(l);
        vids(f).frs(exholes(i).t).imr = l;
        vids(f).frs(exholes(i).t).img = l;
        vids(f).frs(exholes(i).t).imb = l;
    end
    for i = 1:numel(exholes)
        vids(f).frs(exholes(i).t).imr(exholes(i).pix) = cols(exholes(i).id,1);
        vids(f).frs(exholes(i).t).img(exholes(i).pix) = cols(exholes(i).id,2);
        vids(f).frs(exholes(i).t).imb(exholes(i).pix) = cols(exholes(i).id,3);
    end
end

%%
for f = 1:numel(fpaths)
    fpath = fpaths{f};
    v = VideoWriter([fpath 'holetracks.mp4'],'MPEG-4');
    v.Quality = 95;
    v.FrameRate = 30;
    open(v);

    for t = 1:numel(vids(f).frs)
        im = cat(3,cat(3,vids(f).frs(t).imr,vids(f).frs(t).img),vids(f).frs(t).imb);
        writeVideo(v,im);

    end
    close(v)
end
%% plot area hists vs qs.

eds = 0:0.1e4:1.5e4;

histogram(areas(qs==-1),eds,'Normalization','pdf')
hold on
histogram(areas(qs==-0.5),eds,'Normalization','pdf')
histogram(areas(qs==0),eds,'Normalization','pdf')
histogram(areas(qs==0.5),eds,'Normalization','pdf')
histogram(areas(qs==1),eds,'Normalization','pdf')
histogram(areas(qs==1.5),eds,'Normalization','pdf')
