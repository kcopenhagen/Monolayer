function [x, y, q, d] = finddefects(fpath, t)

    r = 6;
    re = makeringelement(r);
    S = loaddata(fpath,t,'order','float');
    dir = loaddata(fpath,t,'dfield','float');
    
    S = trimarray(S,20);
    dir = trimarray(dir,20);

    defs = (S<0.5);
    
    CC = bwconncomp(defs);
    P = regionprops(CC, 'Centroid');
    Centroids = [P.Centroid];
    Centx = round(Centroids(1:2:end-1));
    Centy = round(Centroids(2:2:end));
    nog = ~(Centx<r).*~(Centx>numel(S(1,:))-r).*~(Centy<r).*~(Centy>numel(S(:,1))-r);
    Centx(~nog) = [];
    Centy(~nog) = [];
    q = [];
    d = [];
    
    for i = 1:numel(Centx)
        dirt = dir(Centy(i)-r+1:Centy(i)+r-1,Centx(i)-r+1:Centx(i)+r-1);
        ang1s = dirt(re);
        ang2s = [ang1s(2:end); ang1s(1)];
        ang1s(isnan(ang1s))=[];
        ang2s(isnan(ang2s))=[];
        das = ang2s-ang1s;
        das(das>pi/2)=das(das>pi/2)-pi/2;
        das(das<-pi/2)=das(das<-pi/2)+pi/2;
        q = [q sum(das)/pi];
        if abs(q(i)-0.5) < 0.1
            nx = cos(dirt);
            nxnx = nx.*nx;
            ny = sin(dirt);
            nyny =ny.*ny;
            nxny = nx.*ny;
            [dnxnxdx, ~] = gradient(nxnx);
            [dnxnydx, dnxnydy] = gradient(nxny);
            [~, dnynydy] = gradient(nyny);
            dnxnxdx = dnxnxdx(r,r);
            dnxnydx = dnxnydx(r,r);
            dnxnydy = dnxnydy(r,r);
            dnynydy = dnynydy(r,r);
            d = [d; [dnxnxdx+dnxnydy dnxnydx+dnynydy]];
        elseif abs(q(i)+0.5) < 0.1
            phis = ang1s;
            szdirt = size(dirt);
            [ry, rx] = ind2sub(szdirt,re);
            rx = rx - szdirt(2)/2;
            ry = ry - szdirt(1)/2;
            thetas = atan2(ry,rx);
            phisx = cos(phis);
            phisy = sin(phis);
            thetasx = cos(thetas);
            thetasy = sin(thetas);

            A = abs(phisx.*thetasx+phisy.*thetasy);
            A(isnan(A)) = 0;
            A = [A(end); A; A(1)];
            thetas = [thetas(end)-2*pi; thetas; thetas(1)+2*pi];
            [~, legs] = findpeaks(A,thetas,...
                'SortStr','descend','NPeaks',3,'MinPeakHeight',0.9);

            legmag = abs(legs);
            leggys = sortrows([legmag legs]);
            legs = leggys(:,2);

            mods = [-2*pi/3 0 2*pi/3];
            leg1 = legs(1);
            [~,ij] = min(abs((legs(2)-mods)-leg1));
            leg2 = legs(2)-mods(ij);
            leg3 = NaN;
            if numel(legs)>2
                [~,ij] = min(abs((legs(3)-mods)-leg1));
                leg3 = legs(3)-mods(ij);
            end
            d = [d; cos(mean([leg1 leg2 leg3],'omitnan')) sin(mean([leg1 leg2 leg3],'omitnan'))];
        else
            d = [d; NaN NaN];
        end
    end
    
    x = Centx+20;
    y = Centy+20;

end
    