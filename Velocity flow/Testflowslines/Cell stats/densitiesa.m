files = dir('/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Labeledflows/*mat');

for r1 = 1
    for r2 = 4
densities = [];
    for f = 1:numel(files)
    load([files(f).folder '/' files(f).name ],'p0s','p1s','p2s','ids');
    temp = strsplit(files(f).name,'t');

    folder = temp{1};
    folder = folder(6:end);

    t = temp{2};
    t = strsplit(t,'.');
    t = str2num(t{1});

    fpath = [fileparts(files(f).folder) '/Data/' folder '/'];
    XYcal = getXYcal(fpath);

    im = zeros(768,1024);
    
    aids = unique(ids);
    for ii = 1:numel(aids) %each cell.
        id = aids(ii);
        cp0s = p0s(ids==id,:);
        imc = zeros(768,1024);
        for jj = 1:numel(cp0s(:,1))-1 %each pt in cell
            x1 = cp0s(jj,1);
            x2 = cp0s(jj+1,1);
            y1 = cp0s(jj,2);
            y2 = cp0s(jj+1,2);
            m = (y2-y1)/(x2-x1);
            xxs = round(x1):round(x2);
            if numel(xxs)>1
            xys = round(y1+m*(xxs-x1));
            ind = sub2ind(size(imc),xys,xxs);
            imc(ind) = 1;
            end
            
            yys = round(y1):round(y2);
            if numel(yys)>1
            yxs = round(x1+1/m*(yys-y1));
            ind = sub2ind(size(imc),yys,yxs);
            imc(ind) = 1;
            end
        end
        %imc = imdilate(imc,strel('disk',r));
        im = im+imc;
    end
    se = strel('disk',r1);
    im = imdilate(im>0,se);
    mask = imclose(im,strel('disk',r2));
    l = laserdata(fpath,t-1);
    densities = [densities; id/(0.133^2*sum(mask(:)))];
    im = zeros(768,1024);

    for ii = 1:numel(aids) %each cell.
        id = aids(ii);
        cp0s = p1s(ids==id,:);
        imc = zeros(768,1024);
        for jj = 1:numel(cp0s(:,1))-1 %each pt in cell
            x1 = cp0s(jj,1);
            x2 = cp0s(jj+1,1);
            y1 = cp0s(jj,2);
            y2 = cp0s(jj+1,2);
            m = (y2-y1)/(x2-x1);
            xxs = round(x1):round(x2);
            if numel(xxs)>1
            xys = round(y1+m*(xxs-x1));
            ind = sub2ind(size(imc),xys,xxs);
            imc(ind) = 1;
            end
            
            yys = round(y1):round(y2);
            if numel(yys)>1
            yxs = round(x1+1/m*(yys-y1));
            ind = sub2ind(size(imc),yys,yxs);
            imc(ind) = 1;
            end
        end
        %imc = imdilate(imc,strel('disk',r));
        im = im+imc;
    end
    se = strel('disk',r1);
    im = imdilate(im>0,se);
    mask = imclose(im,strel('disk',r2));
    l = laserdata(fpath,t);
    densities = [densities; id/(0.133^2*sum(mask(:)))];
    im = zeros(768,1024);

    for ii = 1:numel(aids) %each cell.
        
        id = aids(ii);
        cp0s = p2s(ids==id,:);
        imc = zeros(768,1024);
        for jj = 1:numel(cp0s(:,1))-1 %each pt in cell
            x1 = cp0s(jj,1);
            x2 = cp0s(jj+1,1);
            y1 = cp0s(jj,2);
            y2 = cp0s(jj+1,2);
            m = (y2-y1)/(x2-x1);
            xxs = round(x1):round(x2);
            if numel(xxs)>1
            xys = round(y1+m*(xxs-x1));
            ind = sub2ind(size(imc),xys,xxs);
            imc(ind) = 1;
            end
            
            yys = round(y1):round(y2);
            if numel(yys)>1
            yxs = round(x1+1/m*(yys-y1));
            ind = sub2ind(size(imc),yys,yxs);
            imc(ind) = 1;
            end
        end
        %imc = imdilate(imc,strel('disk',r));
        im = im+imc;
    end
    se = strel('disk',r1);
    im = imdilate(im>0,se);
    mask = imclose(im,strel('disk',r2));
    l = laserdata(fpath,t+1);
    densities = [densities; id/(0.133^2*sum(mask(:)))];

    end
plot(densities)
hold on
ylim([0 1])
    end
end