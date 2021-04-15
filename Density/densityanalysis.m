function densityanalysis(datapath)
%%
    load([datapath 'labeled_cells.mat'],'defs','labs');
    donedefs = find([defs.done]);
    denseds = 0:0.05:1;
    
    allds = 2:2:60;
    di = 0;
    
    densityplot = zeros(numel(denseds)-1,numel(allds));
    
    for d = allds
        di = di+1;
        alldens = [];
        for def_is = donedefs

            clabs = labs((([labs.ff]==defs(def_is).ff) ...
                .*([labs.t]==defs(def_is).ts))==1);
            cxs = [clabs.x];
            cys = [clabs.y];
            relx = cxs-defs(def_is).x;
            rely = cys-defs(def_is).y;
            labes = [clabs.l];

            relrs = sqrt(relx.^2+rely.^2);
            labthetas = atan2(rely,relx);
            defdir = atan2(defs(def_is).d(2),defs(def_is).d(1));
            relthetas = defdir-labthetas;
            relxs = relrs.*cos(relthetas);
            relys = relrs.*sin(relthetas);

            relxs2 = relrs.*cos(relthetas + pi/3);
            relys2 = relrs.*sin(relthetas + pi/3);
            relxs3 = relrs.*cos(relthetas + 2*pi/3);
            relys3 = relrs.*sin(relthetas + 2*pi/3);

            x = -141:141;
            y = -141:141;
            [xx,yy] = meshgrid(x,y);

            locdens1 = zeros(size(xx));

            for lab_is = 1:numel(clabs)
                dx = xx-relxs(lab_is);
                dy = yy-relys(lab_is);
                dr = sqrt(dx.^2+dy.^2);

                locdens1(dr<d)=locdens1(dr<d)+clabs(lab_is).l;
            end
            locdens1 = locdens1/(pi*(0.133*d)^2);
            
            alldens = [alldens; locdens1(:)];
            
        end
        cnts = histcounts(alldens,denseds);
        densityplot(:,di) = cnts;
    end
    
    show(densityplot)
    