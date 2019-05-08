function defheight
imsize = 401;
folders = dir('/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Data');
dirFlags = [folders.isdir];
folders = folders(dirFlags);
folders(1:2) = [];
imp = zeros(imsize);
imn = zeros(imsize);
avgclaysp = zeros(imsize);
claycountp = zeros(imsize);
avgclaysn = zeros(imsize);
claycountn = zeros(imsize);

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
    
    
    for t = 1:N-1
        lays = loaddata(fpath,t,'manuallayers','int8');
        lays = round(imgaussfilt(lays,3));
        
        cdefs = ts == t;

        holes = lays == 0;
        CC = bwconncomp(holes);
        P = regionprops(CC,'PixelIdxList','MinorAxisLength');
        Ps = P([P.MinorAxisLength]<39);
        for i = 1:numel(Ps)
            holes(Ps(i).PixelIdxList) = 0;
        end
        
        definds = sub2ind(size(holes),round(y),round(x));
        cdefs(holes(definds)) = false;
        
        laystp1 = loaddata(fpath,t+1,'manuallayers','int8');
        laystp1 = round(imgaussfilt(laystp1,3));
        
        lays = laystp1-lays;
        lays = padarray(lays,[imsize,imsize],NaN,'both');
        
        cxs = x(cdefs);
        cys = y(cdefs);
        cds = d(cdefs,:);
        cqs = q(cdefs);
        
        for i = 1:numel(cxs)
            
            %lays = lays - lays(round(cys(i))+imsize,round(cxs(i))+imsize);
            clays = lays(round(cys(i)):...
                round(cys(i)+(2*imsize)),...
                round(cxs(i)):...
                round(cxs(i)+2*imsize));

            clays = imrotate(clays,atan2d(cds(i,2),cds(i,1)),'nearest','crop');
            clays = clays((imsize+1)/2+1:end-(imsize+1)/2,...
                (imsize+1)/2+1:end-(imsize+1)/2);

            if cqs(i) > 0
                avgclaysp(~isnan(clays)) = avgclaysp(~isnan(clays))...
                    + clays(~isnan(clays));
                claycountp = claycountp + ~isnan(clays);
            elseif cqs(i) < 0
                avgclaysn(~isnan(clays)) = avgclaysn(~isnan(clays))...
                    + clays(~isnan(clays));
                claycountn = claycountn + ~isnan(clays);
            end
        end
    end
    
end

avgclaysp = avgclaysp./claycountp;
avgclaysn = avgclaysn./claycountn;

show(avgclaysp)
colorcet('R2')
caxis([-0.03 0.03]);
hold on
plot(200,200,'w.','MarkerSize',10);
plot([200 210],[200 200],'w','LineWidth',1);

show(avgclaysn)
colorcet('R2')
caxis([-0.03 0.03]);
hold on
plot(200,200,'w.','MarkerSize',10);
plot([200 200+10*cos(0) 200 200+10*cos(2*pi/3) 200 200+10*cos(4*pi/3)],...
    [200 200+10*sin(0) 200 200+10*sin(2*pi/3) 200 200+10*sin(4*pi/3)],...
    'w','LineWidth',1);



