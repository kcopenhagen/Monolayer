function [speeds, speedsperp, speedspar] = cell_speed
files = dir('/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Labeledflows/*mat');
speeds = [];
speedspar = [];
for f = 1:numel(files)
    load([files(f).folder '/' files(f).name ],'p0s','p1s','p2s','ids');
    temp = strsplit(files(f).name,'t');

    folder = temp{1};
    folder = folder(6:end);

    t = temp{2};
    t = strsplit(t,'.');
    t = str2double(t{1});

    fpath = [fileparts(files(f).folder) '/Data/' folder '/'];
    XYcal = getXYcal(fpath);
    
    fid = fopen([fpath 'times.txt']);
    times = fscanf(fid,'%f');
    
    vx1 = p1s(:,1)-p0s(:,1);
    vy1 = p1s(:,2)-p0s(:,2);
    dt1 = times(t)-times(t-1);
    
    vx1 = 60*vx1*XYcal/dt1;
    vy1 = 60*vy1*XYcal/dt1;
    
    vx2 = p2s(:,1)-p1s(:,1);
    vy2 = p2s(:,2)-p2s(:,2);
    dt2 = times(t+1)-times(t);
    
    vx2 = 60*vx2*XYcal/dt2;
    vy2 = 60*vy2*XYcal/dt2;
    
    speeds = [speeds; sqrt(vx1.^2+vy1.^2)];
    speeds = [speeds; sqrt(vx2.^2+vy2.^2)];

%------------------------------------------------------------------------%

    %Project onto cell body.

    xs = [p0s(:,1); p0s(1,1)];
    ys = [p0s(:,2); p0s(1,2)];
    
    x1s = xs(1:end-1);
    y1s = ys(1:end-1);
    x2s = xs(2:end);
    y2s = ys(2:end);
    id1s = ids;
    id2s = [ids(2:end); ids(1)];
    
    dids = id2s-id1s;
    samecell = dids==0;
    
    samecells = zeros(size(dids));
    samecells(samecell) = 1;
    
    dxs = x2s - x1s;
    dys = y2s - y1s;
    
    dxs2 = [dxs(2:end); dxs(1)];
    dys2 = [dys(2:end); dys(1)];
    samecells2 = [samecells(2:end); samecells(1)];
    
    mdxs = (dxs.*samecells+dxs2.*samecells2)./(samecells+samecells2);
    mdys = (dys.*samecells+dys2.*samecells2)./(samecells+samecells2);
    
    mspl = sqrt(mdxs.^2+mdys.^2);
    
    speedspar = [speedspar; (vx1.*mdxs+vy1.*mdys)./mspl];
    
        %Project onto cell body.

    xs = [p1s(:,1); p1s(1,1)];
    ys = [p1s(:,2); p1s(1,2)];
    
    x1s = xs(1:end-1);
    y1s = ys(1:end-1);
    x2s = xs(2:end);
    y2s = ys(2:end);
    id1s = ids;
    id2s = [ids(2:end); ids(1)];
    
    dids = id2s-id1s;
    samecell = dids==0;
    
    samecells = zeros(size(dids));
    samecells(samecell) = 1;
    
    dxs = x2s - x1s;
    dys = y2s - y1s;
    
    dxs2 = [dxs(2:end); dxs(1)];
    dys2 = [dys(2:end); dys(1)];
    samecells2 = [samecells(2:end); samecells(1)];
    
    mdxs = (dxs.*samecells+dxs2.*samecells2)./(samecells+samecells2);
    mdys = (dys.*samecells+dys2.*samecells2)./(samecells+samecells2);
    
    mspl = sqrt(mdxs.^2+mdys.^2);
    
    speedspar = [speedspar; (vx2.*mdxs+vy2.*mdys)./mspl];
end
speedspar(speedspar>speeds) = speeds(speedspar>speeds);

speedspar = abs(speedspar);
speedsperp = sqrt(speeds.^2-speedspar.^2);
speedsperp = real(speedsperp);

