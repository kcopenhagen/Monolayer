function laych = LayerChanges(fpath,t)
laych = [];
no = 1;

[~,~,~] = mkdir([fpath '/analysis/manuallayers']);

files = dir([fpath 'analysis/mlays']);

del = [];
for f = 1:numel(files)
    if files(f).name(1)=='.' 
        del = [del; f];
    end
end
files(del) = [];
try
    lm1 = loaddata(fpath,t-1,'covid_layers','int8');
catch
    lm1 = loaddata(fpath,t-1,'mlays','int8');
end
lm1(lm1<0) = 0;
%lm1 = round(imgaussfilt(lm1,3));
try
    lt = loaddata(fpath,t,'covid_layers','int8');
catch
    lt = loaddata(fpath,t,'mlays','int8');
end
lt(lt<0) = 0;

%lt = round(imgaussfilt(lt,3));
minl = min(lt(:));
maxl = max(lt(:));
for l = minl:maxl
    CC = bwconncomp(lt==l);
    P = regionprops(CC,'PixelIdxList','Centroid','Area');
    for i = 1:numel(P)
        if sum(lm1(P(i).PixelIdxList)==l)<10% && P(i).Area>50
            laych(no).t = t;
            laych(no).fpath = fpath;
            laych(no).x = P(i).Centroid(1);
            laych(no).y = P(i).Centroid(2);
            laych(no).type = 'create';
            laych(no).o = mode(lm1(P(i).PixelIdxList));
            laych(no).n = l;
            laych(no).idx = P(i).PixelIdxList;
            no = no+1;
        end
    end
end

lm1(lm1<0) = 0;
minl = min(lm1(:));
maxl = max(lm1(:));
for l = minl:maxl
    CC = bwconncomp(lm1==l);
    P = regionprops(CC,'PixelIdxList','Centroid','Area');
    for i = 1:numel(P)
        if sum(lt(P(i).PixelIdxList)==l)<10 %&& P(i).Area>50
            laych(no).t = t;
            laych(no).fpath = fpath;
            laych(no).x = P(i).Centroid(1);
            laych(no).y = P(i).Centroid(2);
            laych(no).type = 'destroy';
            laych(no).n = mode(lt(P(i).PixelIdxList));
            laych(no).o = l;
            laych(no).idx = P(i).PixelIdxList;
            no = no+1;
        end
    end
end


