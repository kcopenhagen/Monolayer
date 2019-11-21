function regioncharges(datapath)
fpaths = getfold(datapath);
sz = [768,1024];
walls = zeros(sz);
walls(1:5,:) = 1;
walls(end-4:end,:) = 1;
walls(:,1:5) = 1;
walls(:,end-4:end) = 1;
walls = walls==1;
holeqs = [];
lay2qs = [];
for f = 1:numel(folders)
    fpath = fpaths{f};
    files = dir([fpath 'analysis/dfield']);
    N = numel(files);
    for t = 1:N
        lays = round(imgaussfilt(loaddata(fpath,t,'manuallayers','int8'),3));
        dir = loaddata(fpath,t,'dfield','float');
        holes = lays==0;
        CC = bwconncomp(holes);
        P = regionprops(CC,'PixelIdxList');
        Pw = [];
        for h = 1:numel(P)
            if any(walls([P(h).PixelIdxList]))
                Pw = [Pw; h];
            end
        end
        P(Pw) = [];
        for h = 1:numel(P)
            holeqs = [holeqs; regioncharge(P(h),dir)];
        end
       
        lays2 = lays==2;
        CC = bwconncomp(lays2);
        P = regionprops(CC,'PixelIdxList');
        Pw = [];
        for h = 1:numel(P)
            if any(walls([P(h).PixelIdxList]))
                Pw = [Pw; h];
            end
        end
        P(Pw) = [];
        for h = 1:numel(P)
            lay2qs = [lay2qs; regioncharge(P(h),dir)];
        end
        
        
    end
        
end