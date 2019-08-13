function nemorderfield(fpath,t)
% Calculates local order field of image in fpath, at time t.
%    Saves into analysis/order folder as an array of floats.
%% Calc order
    %r = 0.5;
    r = 0.5;
    XYcal = getXYcal(fpath);
    name = sprintf('%06d.bin',t-1);
    [~,~,~] = mkdir([fpath 'analysis/order']);
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

    S = S(ceil(rr)+1:end-ceil(rr),ceil(rr)+1:end-ceil(rr));
    
    %% Save file
    fID = fopen([fpath 'analysis/order/' name],'w');
    fwrite(fID,S,'float');
    fclose(fID);
    
end