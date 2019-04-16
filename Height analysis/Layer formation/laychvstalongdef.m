function laychvstalongdef
imsize = 401;
folders = dir('/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Data');
dirFlags = [folders.isdir];
folders = folders(dirFlags);
folders(1:2) = [];

tmax = 100;
dclayp = zeros(imsize,imsize,tmax);
dclayn = zeros(imsize,imsize,tmax);
dclaypn = zeros(imsize,imsize,tmax);
dclaynn = zeros(imsize,imsize,tmax);


for f = 1:numel(folders)
%% Calculate defects for current experiment and exclude ones that have charge of 0, or are in holes.

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
    nothole = true(size(q));
    
    N = numel(files);
    for t = 1:N
        lays = loaddata(fpath,t,'manuallayers','int8');
        lays = round(imgaussfilt(lays,3));

        holes = lays == 0;
        CC = bwconncomp(holes);
        P = regionprops(CC,'PixelIdxList','MinorAxisLength');
        Ps = P([P.MinorAxisLength]<39);
        for i = 1:numel(Ps)
            holes(Ps(i).PixelIdxList) = 0;
        end

        definds = sub2ind(size(holes),round(y),round(x));
        nothole(1==(holes(definds)).*(ts==t)) = false;

    end
    
    x(~nothole) = [];
    y(~nothole) = [];
    d(~nothole,:) = [];
    tt(~nothole) = [];
    ts(~nothole) = [];
    id(~nothole) = [];
    q(~nothole) = [];
    
    %% Go through each individual defect and find the change in layer count from its formation to later on.
    
    adef = unique(id);
    
    for i = 1:numel(adef)
        idi = adef(i);
        cdefs = id == idi;
        
        qis = q(cdefs);
        charge = qis(1);
        xis = x(cdefs);
        yis = y(cdefs);
        dis = d(cdefs,:);
        ti = ts(cdefs);
        if numel(ti)>tmax
            ti(tmax+1:end) =[];
        end
        
        for t = 1:numel(ti)
            ct = ti(t);
            lays = loaddata(fpath,ct,'manuallayers','int8');
            
            lays = padarray(lays,[imsize,imsize],NaN,'both');
            
            clays = lays(round(yis(t)):...
                round(yis(t)+(2*imsize)),...
                round(xis(t)):...
                round(xis(t)+2*imsize));

            clays = imrotate(clays,atan2d(dis(t,2),dis(t,1)),'nearest','crop');
            clays = clays((imsize+1)/2+1:end-(imsize+1)/2,...
                (imsize+1)/2+1:end-(imsize+1)/2);
            if t == 1
                clay0 = clays;
            end
            dclays = clays - clay0;
            count = ~isnan(dclays);
            dclays(isnan(dclays)) = 0;
            
            if charge>0
                dclayp(:,:,t) = dclayp(:,:,t) + dclays;
                dclaypn(:,:,t) = dclaypn(:,:,t) + count;
            else 
                dclayn(:,:,t) = dclayn(:,:,t) + dclays;
                dclaynn(:,:,t) = dclaynn(:,:,t) + count;
            end
        end
    end
end

for i = 1:10:tmax
    show(dclayp(:,:,i)./dclaypn(:,:,i))
end

for i = 1:10:tmax
    show(dclayn(:,:,i)./dclaynn(:,:,i))
end
