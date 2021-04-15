function laychs = layervsdef(datapath)
%%
addpath('/Users/kcopenhagen/Documents/MATLAB/gitstuff/Monolayer/Height analysis/Layer formation/IDing Layers');
addpath('/Users/kcopenhagen/Documents/MATLAB/gitstuff/Monolayer/Director field/');
folders = dir(datapath);
dirFlags = [folders.isdir];
folders = folders(dirFlags);
folders(1:2) = [];
laychs = [];

walls = zeros(768,1024);
walls(1:10,:) = 1;
walls(end-10:end,:) = 1;
walls(:,1:10) = 1;
walls(:,end-10:end) = 1;

wallidx = find(walls == 1);

for f = 1:numel(folders)
    
    fpath = [folders(f).folder '/' folders(f).name '/'];
    load([fpath 'adefs.mat'],'adefs');
    %adefs = alldefects(fpath);
    for t = 2:max([adefs.ts])
        laych = LayerChanges(fpath,t);
        del = [];
        try
            holes = loaddata(fpath,t-1,'covid_layers','int8')==0;
        catch
            holes = loaddata(fpath,t-1,'mlays','int8')==0;
        end
        CC = bwconncomp(holes);
        P = regionprops(CC,'PixelIdxList','MinorAxisLength');
        Ps = P([P.MinorAxisLength]<39);
        for i = 1:numel(Ps)
            holes(Ps(i).PixelIdxList) = 0;
        end
        
        for i = 1:numel(laych)
            cdefs = adefs([adefs.ts] == t-1);
            
            dists = sqrt((laych(i).x-[cdefs.x]).^2+(laych(i).y-[cdefs.y]).^2);
            
            ndists = dists([cdefs.q]<0);
            nn = min(ndists);
            
            if ~isempty(nn)
                cln = dists==nn;
            else
                cln = [];
            end
            
            laych(i).nnx = [cdefs(cln).x];
            laych(i).nny = [cdefs(cln).y];
            laych(i).nnd = [cdefs(cln).d];
            
            pdists = dists([cdefs.q]>0);
            
            np = min(pdists);
            if ~isempty(np)
                clp = dists==np;
            else
                clp = [];
            end
            
            laych(i).npx = [cdefs(clp).x];
            laych(i).npy = [cdefs(clp).y];
            laych(i).npd = [cdefs(clp).d];
            
            laych(i).dwall = min([laych(i).x, 1024 - laych(i).x,laych(i).y,768-laych(i).y]);
            laych(i).pd = pdists;
            laych(i).nd = ndists;
            
            if ~isempty(intersect(laych(i).idx,wallidx))
                del = [del; i];
            end
            
        end

        laych(del) = [];
        
        laychs = [laychs laych];
    end
end