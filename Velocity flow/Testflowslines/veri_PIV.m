function [dtheta, magrat] = veri_PIV(dx)
addpath('../PIV/');

function [vxint,vyint] = interpv(xs,ys,vx,vy,xx,yy)
    vxint = zeros(size(xx));
    vyint = zeros(size(yy));
    
    for i = 1:numel(xx)
        x = xx(i);
        y = yy(i);
        x1 = find(xs==max(xs(xs<x)));
        x2 = find(xs==min(xs(xs>x)));
        y1 = find(ys==max(ys(ys<y)));
        y2 = find(ys==min(ys(ys>y)));

        vx11 = vx(y1,x1);
        vx12 = vx(y2,x1);
        vx21 = vx(y1,x2);
        vx22 = vx(y2,x2);
        
        vy11 = vy(y1,x1);
        vy12 = vy(y2,x1);
        vy21 = vy(y1,x2);
        vy22 = vy(y2,x2);
        
        vxint(i) = 1/((xs(x2)-xs(x1))*(ys(y2)-ys(y1)))...
            *(vx11*(xs(x2)-x)*(ys(y2)-y)+vx21*(x-xs(x1))*(ys(y2)-y)...
            + vx12*(xs(x2)-x)*(y-ys(y1))+vx22*(x-xs(x1))*(y-ys(y1)));
        vyint(i) = 1/((xs(x2)-xs(x1))*(ys(y2)-ys(y1)))...
            *(vy11*(xs(x2)-x)*(ys(y2)-y)+vy21*(x-xs(x1))*(ys(y2)-y)...
            + vy12*(xs(x2)-x)*(y-ys(y1))+vy22*(x-xs(x1))*(y-ys(y1)));

    end
end
files = dir('/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Labeledflows/*mat');

dtheta = [];
magrat = [];
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
    dt1 = 1/60*(times(t)-times(t-1));
    dt2 = 1/60*(times(t+1)-times(t));
    
    [cxs,cys,cvx,cvy] = PIV(fpath,t-1,dx);

    lxs = p0s(:,1);
    lys = p0s(:,2);
    lvx = p1s(:,1)-p0s(:,1);
    lvy = p1s(:,2)-p0s(:,2);
    lvx = XYcal*lvx/dt1;
    lvy = XYcal*lvy/dt1;
    [vxint,vyint] = interpv(cxs,cys,cvx,cvy,lxs,lys);

    lvmag = sqrt(lvx.^2+lvy.^2);
    vintmag = sqrt(vxint.^2+vyint.^2);

    dtheta = [dtheta; acos((vxint.*lvx+vyint.*lvy)./(vintmag.*lvmag))];
    magrat = [magrat; lvmag-vintmag];
    
    [cxs,cys,cvx,cvy] = PIV(fpath,t,dx);

    lxs = p1s(:,1);
    lys = p1s(:,2);
    lvx = p2s(:,1)-p1s(:,1);
    lvy = p2s(:,2)-p1s(:,2);
    lvx = XYcal*lvx/dt2;
    lvy = XYcal*lvy/dt2;
    
    [vxint,vyint] = interpv(cxs,cys,cvx,cvy,lxs,lys);
    
    lvmag = sqrt(lvx.^2+lvy.^2);
    vintmag = sqrt(vxint.^2+vyint.^2);

    dtheta = [dtheta; acos((vxint.*lvx+vyint.*lvy)./(vintmag.*lvmag))];
    magrat = [magrat; lvmag-vintmag];
    
%     quiver(lxs,lys,lvx,lvy,'r','LineWidth',2,'AutoScale','off');
%     hold on
%     quiver(lxs,lys,vxint,vyint,'g','LineWidth',2,'AutoScale','off');
%     hold on
end

end