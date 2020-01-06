

%%
fpaths = getfold(datapath);
lay2 = [];

for f = 1:numel(fpaths)
    fpath = fpaths{f};
    ts = getts(fpath);

    for t = 1:numel(ts)
        %% Identifying layers and holes for tracking.
        fpath = fpaths{f};
        try
        lays = loaddata(fpath,t,'manuallayers','int8');
        lays = round(imgaussfilt(lays,3));

        layers = lays==2;
        layers = imclearborder(layers);

        CC = bwconncomp((layers));
        P = regionprops(CC,'PixelIdxList');
        for j = 1:numel(P)
            lj = numel(lay2)+1;
            lay2(lj).PixList = P(j).PixelIdxList;
            lay2(lj).t = t;
            lay2(lj).id = -1;
            lay2(lj).fpath = fpath;
        end

        end
    end
    
end
%% Track layers
i = find([lay2.id]==-1,1);
clab = 1;

while sum([lay2.id]==-1)>0
    lay2(i).id = clab;
    js = find([lay2.t] == lay2(i).t+1);
    del = [];
    for j = js
        if string(lay2(j).fpath) ~= string(lay2(i).fpath)
            del = [del; j];
        end
    end
    js(ismember(js,del)) = [];
    
    ni = [];
    for j = js
        if intersect([lay2(j).PixList],[lay2(i).PixList])
            ni = [ni; j];
        end
    end

    if numel(ni) == 1
        js2 = find([lay2.t] == lay2(ni).t-1);
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

%%
lay2long = lay2;
ids = unique([lay2long.id]);
del = [];
for i = 1:numel(ids)
    id = ids(i);
    clay = lay2long([lay2long.id] == id);
    if numel(clay) <5
        del = [del; i];
    end
end
lay2long(ismember([lay2long.id],del)) = [];
%% 
ids = unique([lay2long.id]);
figure
laytracks = [];

for i = 1:numel(ids)
    id = ids(i);
    clays = lay2long([lay2long.id] == id);
    sz = [];
    q = [];
    for t= 1:numel(clays)
        sz = [sz; numel([clays(t).PixList])*(0.133^2)];
        clays(t).PixelIdxList = clays(t).PixList;
        dfield = loaddata(clays(t).fpath,clays(t).t,'dfield','float');
        q = [q; regioncharge(clays(t),dfield)];
    end
    
    plot(sz(q==0.5),'r');
    hold on
    plot(sz(q==0),'k');
    laytracks(i).size = sz;
    laytracks(i).q = q;
    
end

%%

dss = [];
qs = [];
for i = 1:numel(laytracks)
    sz2 = [laytracks(i).size];
    sz2 = smooth(sz2);
    sz1 = sz2(1:end-1);
    sz2(1) = [];
    ds = sz2-sz1;
    
    q = laytracks(i).q;
    q(end) = [];
    
    dss = [dss; ds];
    qs = [qs; q];
    
end
eds = -20:2:20;
histogram(dss(qs==0.5),eds,'FaceColor','r','Normalization','pdf');
hold on
histogram(dss(qs==0),eds,'FaceColor','k','Normalization','pdf');
set(gca,'FontSize',18);
%% small ds

dss = [];
qs = [];
for i = 1:numel(laytracks)
    sz2 = [laytracks(i).size];
    q = laytracks(i).q;

    sz2 = smooth(sz2);
    q(sz2>6.25) = [];
    sz2(sz2>6.26) = [];

    if numel(sz2)>0
        sz1 = sz2(1:end-1);
        sz2(1) = [];
        ds = sz2-sz1;

        q(end) = [];

        dss = [dss; ds];
        qs = [qs; q];
    end
    
end

eds = -20:2:20;
histogram(dss(qs==0.5),eds,'FaceColor','r','Normalization','pdf');
hold on
histogram(dss(qs==0),eds,'FaceColor','k','Normalization','pdf');
set(gca,'FontSize',18);
%%
szs = [];
qs = [];
for i = 1:numel(laytracks)
    
    szs = [szs; laytracks(i).size];
    qs = [qs; laytracks(i).q];
end
eds = 0:30:500;
histogram(szs(qs==0.5),eds,'FaceColor','r','Normalization','pdf');
hold on
histogram(szs(qs==0),eds,'FaceColor','k','Normalization','pdf');
set(gca,'FontSize',18);