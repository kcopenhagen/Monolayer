function dfield(fpath,t,n)
    addpath(genpath('../functions'));
    [~,~,~] = mkdir(fpath,'analysis');
    [~,~,~] = mkdir(fpath,'analysis/dfield/');
    
    l = laserdata(fpath,t);
    ls = imsharpen(l,'Radius',3,'Amount',3);

    dl = 1/2*[-1 0 1];

    dx = zeros(numel(dl),numel(dl));
    dx(end/2+1/2,:) = dl;
    dy = zeros(numel(dl),numel(dl));
    dy(:,end/2+1/2) = dl;

    lx = conv2(ls,dx,'same');
    ly = conv2(ls,dy,'same');

    J11 = lx.^2;
    J12 = lx.*ly;
    J22 = ly.^2;

    J11 = (imgaussfilt(J11,n));
    J12 = (imgaussfilt(J12,n));
    J22 = (imgaussfilt(J22,n));

    %L2 = (J11+J22)/2-sqrt((J11-J22).^2/4+J12.^2);

    VX = -J12;
    VY = (J11-J22)/2+sqrt((J22-J11).^2/4+J12.^2);

    dirf = atan(VY./VX);
    
    name = sprintf('%06d.bin',t-1);
    fID = fopen([fpath '/analysis/dfield/' name],'w');
    fwrite(fID,dirf,'float');
    fclose(fID);
    
end

