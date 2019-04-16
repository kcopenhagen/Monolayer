function growth = cell_growth
files = dir('/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Labeledflows/*mat');

growth = [];
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
    
    dt1 = (times(t)-times(t-1))/60;
    dt2 = (times(t+1)-times(t))/60;
    cells = unique(ids);

    for i = 1:numel(cells)
        x0s = p0s(:,1);
        y0s = p0s(:,2);
        cxs = x0s(ids == cells(i));
        cys = y0s(ids == cells(i)); 
        l = 0;
        for j = 1:numel(cxs)-1
            l = l + sqrt((cxs(j+1)-cxs(j))^2+(cys(j+1)-cys(j))^2);
        end
        l0 = l*XYcal;
        
        x1s = p1s(:,1);
        y1s = p1s(:,2);
        cxs = x1s(ids == cells(i));
        cys = y1s(ids == cells(i)); 
        l = 0;
        for j = 1:numel(cxs)-1
            l = l + sqrt((cxs(j+1)-cxs(j))^2+(cys(j+1)-cys(j))^2);
        end
        l1 = l*XYcal;
        
        x2s = p2s(:,1);
        y2s = p2s(:,2);
        cxs = x2s(ids == cells(i));
        cys = y2s(ids == cells(i)); 
        l = 0;
        for j = 1:numel(cxs)-1
            l = l + sqrt((cxs(j+1)-cxs(j))^2+(cys(j+1)-cys(j))^2);
        end
        
        l2 = l*XYcal;

        growth = [growth; (l1-l0)./dt1];
        growth = [growth; (l2-l1)./dt2];
    end
end
    