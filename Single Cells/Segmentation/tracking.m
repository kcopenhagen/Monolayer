fpaths = getfold(datapath);
clab = 1;
acells = [];

%% The loop
fdzgpo
for f = 1:numel(fpaths)
    %% Find all the cells.
    fpath = fpaths{f};
    ts = getts(fpath);
    XYcal = getXYcal(fpath);
    cells = [];
    for t = 1:min(numel(ts),600)
        l = laserdata(fpath,t);
        lBW = lbinarize(l);
        cellst = segmentcells(lBW);
        for i = 1:numel(cellst)
            cellst(i).t = t;
            cellst(i).ts = ts(t);
            cellst(i).id = -1;
            cellst(i).rev = 0;
            cellst(i).fpath = fpath;
        end
        cells = [cells; cellst];
    end
    "Cells found"
    %% Track the cells between frames by pixel overlap.
    
    i = find([cells.id]==-1,1);
    
    while sum([cells.id]==-1)>0
        cells(i).id = clab;
        js = find([cells.t] == cells(i).t+1);
        ni = [];
        for j = js
            if intersect([cells(j).PixelIdxList],[cells(i).PixelIdxList])
                if abs(cells(j).MajorAxisLength-cells(i).MajorAxisLength)<100
                    ni = [ni; j];
                end
            end
        end
        
        if numel(ni) == 1
            i = ni;
        else
            i = find([cells.id]==-1,1);
            clab = clab+1;
        end
    end
    "Cells tracked"
    %% Exclude cells whose tracks are less than x frames.
    [a,b] = histcounts([cells.id],'BinMethod','integer');
    
    b = b(2:end)-0.5;
    ids = b(a>20);
    
    cells = cells(ismember([cells.id],ids));

    %% Find drift
    l = laserdata(fpath,1);
    l = l./imgaussfilt(l,64);
    l = 2*normalise(l)-1;
    dr = [0 0];
    for t = 2:max([cells.t])
        lp = l;
        l = laserdata(fpath,t);
        l = l./imgaussfilt(l,64);
        l = 2*normalise(l)-1;
        h = xcorr_fft(l,lp);
        p = xcorrpeak(h);
        center = size(lBW')/2+1;
        
        dr = [dr; center-p];
    end
    "Drift calculated"
    %% Find cell speeds.
    ids = unique([cells.id]);
    
    for j = 1:numel(ids)
        ccells = cells([cells.id] == ids(j));
        mask = zeros(size(lBW));
        mask([ccells(1).PixelIdxList])=1;
        t2 = ccells(1).ts;
        vs = [0 0];
        for i = 2:numel(ccells)
            t1 = t2;
            t2 = ccells(i).ts;
            pmask = mask;
            mask = zeros(size(lBW));
            mask([ccells(i).PixelIdxList])=1;
            
            h = xcorr_fft(mask,pmask);
            p = xcorrpeak(h);
            
            center = size(lBW')/2+1;
            
            vt = (center-p)-dr(ccells(i).t,:);
            vs = [vs; vt*XYcal./((t2-t1)/60)];

        end
        
        vxs = vs(:,1);
        vys = vs(:,2);
        
        vxs = smooth(vxs,3);
        vys = smooth(vys,3);
        angles = [];
        for i = 1:numel(ccells)-1
            angles = [angles; acos((vxs(i)*vxs(i+1)+vys(i)*vys(i+1))...
                /(sqrt(vxs(i)^2+vys(i)^2)*sqrt(vxs(i+1)^2+vys(i+1)^2)))];
        end
        angles = [angles; 0];
        
        for i = 1:numel(ccells)
            ccells(i).v = [vxs(i) vys(i)];
            ccells(i).angle = angles(i);
        end
        
        acells = [acells; ccells];
    end

    "Speeds calculated"


end

