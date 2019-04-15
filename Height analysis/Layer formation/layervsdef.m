function laychs = layervsdef()
folders = dir('/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Data');
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
    files = dir([fpath 'Laser/']);
    dirFlags = [files.isdir];
    files = files(~dirFlags);
    
    [x,y,q,d,tt,ts,id] = alldefects(fpath);
    x(q==0) = [];
    y(q==0) = [];
    d(q==0,:) = [];
    tt(q==0) = [];
    ts(q==0) = [];
    id(q==0) = [];
    q(q==0) = [];
    
    N = numel(files);
    for t = 2:N-1
        laych = LayerChanges(fpath,t);
        del = [];
        holes = loaddata(fpath,t-1,'manuallayers','int8')==0;
        
        CC = bwconncomp(holes);
        P = regionprops(CC,'PixelIdxList','MinorAxisLength');
        Ps = P([P.MinorAxisLength]<39);
        for i = 1:numel(Ps)
            holes(Ps(i).PixelIdxList) = 0;
        end
        for i = 1:numel(laych)
            cdefs = ts == t-1;

            definds = sub2ind(size(holes),round(y),round(x));
            
            cdefs(holes(definds)) = false;
            
            defxs = x(cdefs);
            defys = y(cdefs);
            
            cds = d(cdefs,:);
            cqs = q(cdefs);
            
            dists = sqrt((laych(i).x-defxs).^2+(laych(i).y-defys).^2);
            laych(i).nn = min(dists(cqs<0));
            cln = dists==laych(i).nn;
            
            
            r = [defxs(cln)-laych(i).x,defys(cln)-laych(i).y];
            dt1 = cds(cln,:);
            dt2 = [cds(cln,1)*cos(2*pi/3)-cds(cln,2)*sin(2*pi/3), ...
                cds(cln,1)*sin(2*pi/3)+cds(cln,2)*cos(2*pi/3)];
            dt3 = [cds(cln,1)*cos(4*pi/3)-cds(cln,2)*sin(4*pi/3), ...
                cds(cln,1)*sin(4*pi/3)+cds(cln,2)*cos(4*pi/3)];   
            
            nnang1 = acos((r(1)*dt1(1)+r(2)*dt1(2))/(sqrt(r(1)^2 ...
                + r(2)^2)*sqrt(dt1(1)^2+dt1(2)^2)));
            nnang2 = acos((r(1)*dt2(1)+r(2)*dt2(2))/(sqrt(r(1)^2 ...
                + r(2)^2)*sqrt(dt2(1)^2+dt2(2)^2)));
            nnang3 = acos((r(1)*dt3(1)+r(2)*dt3(2))/(sqrt(r(1)^2 ...
                + r(2)^2)*sqrt(dt3(1)^2+dt3(2)^2)));
            
            
            laych(i).nnang = min([nnang1, nnang2, nnang3]);
            laych(i).nnor = atan(cds(cln,2)/cds(cln,1));
            
            laych(i).np = min(dists(cqs>0));
            clp = dists==laych(i).np;
            
            r = [defxs(clp)-laych(i).x,defys(clp)-laych(i).y];
            dt = cds(clp,:);
            
            laych(i).npang = acos((r(1)*dt(1)+r(2)*dt(2))/(sqrt(r(1)^2 ...
                + r(2)^2)*sqrt(dt(1)^2+dt(2)^2)));
            laych(i).npor = atan(cds(clp,2)/cds(clp,1));

            laych(i).dwall = min([laych(i).x, 1024 - laych(i).x,laych(i).y,768-laych(i).y]);
            if ~isempty(intersect(laych(i).idx,wallidx))
                del = [del; i];
            end
        end
        
        laych(del) = [];
        
        laychs = [laychs laych];
    end
end