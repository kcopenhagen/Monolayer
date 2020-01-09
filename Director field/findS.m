function S = findS(fpath,t,r)

    XYcal = getXYcal(fpath);

    try
        dir = loaddata(fpath,t,'dfield','float');
    catch
        msgbox(['Run dfield calculations for ' fpath ' at time t = ' t '...']);
        return
    end
    
    rr = round(r/XYcal);
    se = strel('disk',rr);
    dir = padarray(dir,[ceil(rr),ceil(rr)],'replicate','both');
    nhood = se.Neighborhood/sum(sum(se.Neighborhood));
    
    vx = cos(2*dir);
    vy = sin(2*dir);

    vxvx = vx.*vx;
    vxvy = vx.*vy;
    vyvy = vy.*vy;
    a = 2*conv2(vxvx,nhood,'same')-1;
    bc = 2*conv2(vxvy,nhood,'same');
    d = 2*conv2(vyvy,nhood,'same')-1;
    l1 = ((a+d)+sqrt((a+d).^2-4*(a.*d-bc.^2)))/2;
    l2 = ((a+d)-sqrt((a+d).^2-4*(a.*d-bc.^2)))/2;
    S = max(l1,l2);

%     show(a+d)
%     show(S)
