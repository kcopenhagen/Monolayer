function nemorderfield(fpath,t)
%Takes in Hlines and outputs the nematic order accross the image.
% dr is the box size for gridded order parameter in microns.
% drn is the distance from the center of the box to all neighbors being
% calculated in the order paramater.
    r = 0.5;
    XYcal = getXYcal(fpath);
    name = sprintf('%06d.bin',t-1);
    [~,~,~] = mkdir([fpath 'analysis/order']);
    dir = loaddata(fpath,t,'dfield','float');

    sz = size(dir);
    rr = round(r/XYcal);
    se = strel('disk',rr);
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

    fID = fopen([fpath 'analysis/order/' name],'w');
    fwrite(fID,S,'float');
    fclose(fID);
    
end