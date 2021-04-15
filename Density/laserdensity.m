function laserdensity(datapath)  

%%
    d = 20;
    fpaths = getfold(datapath);
    load([datapath 'labeled_cells.mat'],'defs','labs');

    totp = zeros([401 401]);
    totn = zeros([401 401]);
    
    pnum = zeros([401 401]);
    nnum = zeros([401 401]);
    
    for def_is = 1:numel(defs)
%%
        defdir = atan2(defs(def_is).d(2),defs(def_is).d(1));

        laser = laserdata(fpaths{defs(def_is).ff},defs(def_is).ts);
        laser = laser./imgaussfilt(laser,64);
        laser = padarray(laser,[401 401],'both');
        laser = laser((defs(def_is).y-400+401):(defs(def_is).y+400+401),...
            (defs(def_is).x-400+401):(defs(def_is).x+400+401));

        lays = loaddata(fpaths{defs(def_is).ff},defs(def_is).ts,...
            'covid_layers','int8');
        lays = padarray(lays,[401 401],'both');
        lay1 = lays==1;
        lay1 = imerode(lay1,strel('disk',d));
        
        lay1 = lay1((defs(def_is).y-400+401):(defs(def_is).y+400+401),...
            (defs(def_is).x-400+401):(defs(def_is).x+400+401));

        filt = strel('disk',d).Neighborhood;
        laser(lay1~=1) = 0;
        
        laser1 = imrotate(laser,defdir*360/(2*pi),'nearest','crop');
        lay11 = imrotate(lay1,defdir*360/(2*pi),'nearest','crop');
        laser1 = laser1(201:601,201:601);
        lay11 = lay11(201:601,201:601);
        laserdens = conv2(laser1,filt,'same');
        norm = conv2(lay11,filt,'same');
        ldens1 = laserdens./norm;
        ldens1(~lay11) = 0;
        %ldens1 = ldens1(59:341,59:341);        

        laser2 = imrotate(laser,(defdir+2*pi/3)*360/(2*pi),'nearest','crop');
        lay12 = imrotate(lay1,(defdir+2*pi/3)*360/(2*pi),'nearest','crop');
        laser2 = laser2(200:600,200:600);
        lay12 = lay12(200:600,200:600);
        laserdens = conv2(laser2,filt,'same');
        norm = conv2(lay12,filt,'same');
        ldens2 = laserdens./norm;
        ldens2(~lay12) = 0;
        %ldens2 = ldens2(59:341,59:341);  
        
        laser3 = imrotate(laser,(defdir+4*pi/3)*360/(2*pi),'nearest','crop');
        lay13 = imrotate(lay1,(defdir+4*pi/3)*360/(2*pi),'nearest','crop');
        laser3 = laser3(200:600,200:600);
        lay13 = lay13(200:600,200:600);
        laserdens = conv2(laser3,filt,'same');
        norm = conv2(lay13,filt,'same');
        ldens3 = laserdens./norm;
        ldens3(~lay13) = 0;
        %ldens3 = ldens3(59:341,59:341);  
        
        if (defs(def_is).q>0)
            totp = totp + ldens1;
            pnum = pnum + lay11;
        elseif (defs(def_is).q<0)
            totn = totn + ldens1 + ldens2 + ldens3;
            nnum = nnum+lay11+lay12+lay13;
        end
 

    end
    avgp = totp./pnum;
    avgn = totn./nnum;
    
%%
    fig = figure('Units','pixels','Position',[100 100 243 243]);
    ax = axes(fig,'Position',[0 0 1 1]);
    imagesc(ax,avgp)
    colorcet('L4');
    %set(ax, 'CLim',[0 0.6]);
    axis equal
    fig = figure('Units','pixels','Position',[100 100 243 243]);
    ax = axes(fig,'Position',[0 0 1 1]);
    imagesc(ax,avgn)
    colorcet('L4');
    %set(ax, 'CLim',[0 0.6]);
    axis equal
    
end