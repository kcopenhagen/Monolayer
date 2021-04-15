function defectdensity(datapath)
%%
    load([datapath 'labeled_cells.mat'],'defs','labs');
    donedefs = find([defs.done]);
    d = 40;
    x = -141:141;
    y = -141:141;
    [xx,yy] = meshgrid(x,y);
    totp = zeros(size(xx));
    totn = zeros(size(xx));

    pnum = 0;
    nnum = 0;
    alldens = [];
    for def_is = donedefs

        clabs = labs((([labs.ff]==defs(def_is).ff) ...
            .*([labs.t]==defs(def_is).ts))==1);
        cxs = [clabs.x];
        cys = [clabs.y];
        relx = cxs - defs(def_is).x;
        rely = cys - defs(def_is).y;
        labes = [clabs.l];

        relrs = sqrt(relx.^2+rely.^2);
        labthetas = atan2(rely,relx);
        defdir = atan2(defs(def_is).d(2),defs(def_is).d(1));
        defdir = 0;
        relthetas = defdir-labthetas;
        relxs = relrs.*cos(relthetas);
        relys = relrs.*sin(relthetas);

        relxs2 = relrs.*cos(relthetas + 2*pi/3);
        relys2 = relrs.*sin(relthetas + 2*pi/3);
        relxs3 = relrs.*cos(relthetas + 4*pi/3);
        relys3 = relrs.*sin(relthetas + 4*pi/3);

        locdens1 = zeros(size(xx));
        locdens2 = zeros(size(xx));
        locdens3 = zeros(size(xx));

        for lab_is = 1:numel(clabs)
            dx = xx-relxs(lab_is);
            dy = yy-relys(lab_is);
            dr = sqrt(dx.^2+dy.^2);
            %locdens1(dr<d)=locdens1(dr<d)+clabs(lab_is).l;
            locdens1(dr<d)=locdens1(dr<d)+1;
            
            dx = xx-relxs2(lab_is);
            dy = yy-relys2(lab_is);
            dr = sqrt(dx.^2+dy.^2);
            %locdens2(dr<d)=locdens2(dr<d)+clabs(lab_is).l;
            locdens2(dr<d)=locdens2(dr<d)+1;
            
            dx = xx-relxs3(lab_is);
            dy = yy-relys3(lab_is);
            dr = sqrt(dx.^2+dy.^2);
            %locdens3(dr<d)=locdens3(dr<d)+clabs(lab_is).l;
            locdens3(dr<d)=locdens3(dr<d)+1;
        end
        
        locdens1 = locdens1/(pi*(0.133*d)^2);
        locdens2 = locdens2/(pi*(0.133*d)^2);
        locdens3 = locdens3/(pi*(0.133*d)^2);
        
        if (defs(def_is).q>0)
            totp = totp + locdens1;
            pnum = pnum + 1;
        elseif (defs(def_is).q<0)
            totn = totn + locdens1 + locdens2 + locdens3;
            nnum = nnum+3;
        end
        
        alldens = [alldens; locdens1(:)];
        
    end
    
    avgp = totp/pnum;
    avgn = totn/nnum;
    
    %% Plot
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
    