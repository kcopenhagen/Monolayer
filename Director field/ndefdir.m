function d = ndefdir(fpath, t,x,y)
    
    r = 6;
    re = makeringelement(r);
    XYcal = getXYcal(fpath);
    dir = loaddata(fpath,t,'dfield','float');
    
    dirt = dir(round(y)-r+1:round(y)+r-1,...
        round(x)-r+1:round(x)+r-1);

    phis = dirt(re);
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
    [~,i] = min(abs((legs(2)-mods)-leg1));
    leg2 = legs(2)-mods(i);
    leg3 = NaN;
    if numel(legs)>2
        [~,i] = min(abs((legs(3)-mods)-leg1));
        leg3 = legs(3)-mods(i);
    end
    d = [cos(mean([leg1 leg2 leg3],'omitnan')) sin(mean([leg1 leg2 leg3],'omitnan'))];

end

