function [dtheta,magrat] = veri_Oflow(nf,gf,imf)

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
    fclose(fid);
    dt1 = 1/60*(times(t)-times(t-1));
    dt2 = 1/60*(times(t+1)-times(t));
    
    if t-(nf+1)/2>0 && t+(nf+1)/2<numel(times)
        %flow = calctestflow(fpath,t,nf,gf,imf);
        Vx = loaddata(fpath,t,'flows/Vx','float');
        Vy = loaddata(fpath,t,'flows/Vy','float');
        xs = p1s(:,1);
        ys = p1s(:,2);

%        inds = sub2ind(size(flow.Vx),round(ys),round(xs));
        inds = sub2ind(size(Vx),round(ys),round(xs));
        %cvx = flow.Vx(inds);
        %cvy = flow.Vy(inds);
        cvx = Vx(inds);
        cvy = Vy(inds);
        
        lvx = p2s(:,1)-p0s(:,1);
        lvy = p2s(:,2)-p0s(:,2);

        lvmag = sqrt(lvx.^2+lvy.^2);
        cvmag = sqrt(cvx.^2+cvy.^2);

        dtheta = [dtheta; acos((cvx.*lvx+cvy.*lvy)./(cvmag.*lvmag))];
        magrat = [magrat; cvmag./lvmag];
    end
end
