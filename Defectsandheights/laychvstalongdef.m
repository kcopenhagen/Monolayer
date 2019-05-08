function laychvstalongdef(datapath)
addpath('../Director field');
imsize = 401;
folders = dir(datapath);
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
    
    adefs = alldefects(fpath);

    x = [adefs.x];
    y = [adefs.y];
    dt = [adefs.d];
    d = [dt(1:2:end-1)' dt(2:2:end)'];
    q = [adefs.q];
    tt = [adefs.tt];
    ts = [adefs.ts];
    id = [adefs.id];

    
    N = numel(files);
    
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

            clays1 = imrotate(clays,atan2d(dis(t,2),dis(t,1)),'nearest','crop');
            clays1 = clays1((imsize+1)/2+1:end-(imsize+1)/2,...
                (imsize+1)/2+1:end-(imsize+1)/2);
            clays2 = imrotate(clays,2*pi/3 + atan2d(dis(t,2),dis(t,1)),'nearest','crop');
            clays2 = clays2((imsize+1)/2+1:end-(imsize+1)/2,...
                (imsize+1)/2+1:end-(imsize+1)/2);
            clays3 = imrotate(clays,4*pi/3 + atan2d(dis(t,2),dis(t,1)),'nearest','crop');
            clays3 = clays3((imsize+1)/2+1:end-(imsize+1)/2,...
                (imsize+1)/2+1:end-(imsize+1)/2);
                        
            if t == 1
                clay0 = clays1;
            end
            dclays = clays1 - clay0;
            count = ~isnan(clays1);
            count2 = ~isnan(clays2);
            count3 = ~isnan(clays3);
            clays1(isnan(clays1)) = 0;
            clays2(isnan(clays2)) = 0;
            clays3(isnan(clays3)) = 0;
            dclays(isnan(dclays)) = 0;
            
            if charge>0
                dclayp(:,:,t) = dclayp(:,:,t) + clays1;
                dclaypn(:,:,t) = dclaypn(:,:,t) + count;
            else 
                dclayn(:,:,t) = dclayn(:,:,t) + clays1;
                dclaynn(:,:,t) = dclaynn(:,:,t) + count;
                dclayn(:,:,t) = dclayn(:,:,t) + clays2;
                dclaynn(:,:,t) = dclaynn(:,:,t) + count2;
                dclayn(:,:,t) = dclayn(:,:,t) + clays3;
                dclaynn(:,:,t) = dclaynn(:,:,t) + count3;
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

