files = dir('/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Labeledflows/*mat');
nc = 0;
meanerr = [];
for gf = 3:2:13
    thetaerr = [];
    magrat = [];
    nf = 5;
    imf = 1;

    for f = 1:numel(files)
        load([files(f).folder '/' files(f).name ]);
        max(ids)
        temp = strsplit(files(f).name,'t');

        folder = temp{1};
        folder = folder(6:end);

        t = temp{2};
        t = strsplit(t,'.');
        t = str2num(t{1});

        fpath = [fileparts(files(f).folder) '/Data/' folder '/'];

        flow = calctestflow(fpath,t,nf,gf,imf);

        xs = p1s(:,1);
        ys = p1s(:,2);
        lvx1 = p1s(:,1)-p0s(:,1);
        lvx2 = p2s(:,1)-p1s(:,1);
        lvxt = p2s(:,1)-p0s(:,1);
        lvy1 = p1s(:,2)-p0s(:,2);
        lvy2 = p2s(:,2)-p1s(:,2);
        lvyt = p2s(:,2)-p0s(:,2);
        lvtmag = sqrt(lvxt.^2+lvyt.^2);

        sz = size(flow.Vx);
        inds = sub2ind(sz,round(ys),round(xs));
        vx = flow.Vx(inds);
        vy = flow.Vy(inds);
        vmag = sqrt(vx.^2+vy.^2);

        thetaerr = [thetaerr; acos((vx.*lvxt+vy.*lvyt)./(vmag.*lvtmag))];
        magrat = [magrat; vmag./lvtmag];

    end
    figure
    histogram(thetaerr,50)
    meanerr = [meanerr; nanmean(thetaerr)];
end