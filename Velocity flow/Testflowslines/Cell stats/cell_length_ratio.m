function lengths = cell_length_ratio
%Returs the ratio of the actual length of cell splines to the distance from
%one end of the cell to the other.

files = dir('/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Labeledflows/*mat');
lengths = [];
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
%------------------------------------------------------------------------%
    
    xs = p0s(:,1);
    ys = p0s(:,2);
    
    cells = unique(ids);
    for i = 1:numel(cells)
        cxs = xs(ids == cells(i));
        cys = ys(ids == cells(i)); 
        l = 0;
        for j = 1:numel(cxs)-1
            l = l + sqrt((cxs(j+1)-cxs(j))^2+(cys(j+1)-cys(j))^2);
        end
        l2 = sqrt((cxs(end)-cxs(1))^2+(cys(end)-cys(1))^2);
        lengths = [lengths; l/l2];
    end
%------------------------------------------------------------------------%
    
    xs = p1s(:,1);
    ys = p1s(:,2);
    
    cells = unique(ids);
    for i = 1:numel(cells)
        cxs = xs(ids == cells(i));
        cys = ys(ids == cells(i)); 
        l = 0;
        for j = 1:numel(cxs)-1
            l = l + sqrt((cxs(j+1)-cxs(j))^2+(cys(j+1)-cys(j))^2);
        end
        l2 = sqrt((cxs(end)-cxs(1))^2+(cys(end)-cys(1))^2);
        lengths = [lengths; l/l2];
    end
%------------------------------------------------------------------------%
    
    xs = p2s(:,1);
    ys = p2s(:,2);
    
    cells = unique(ids);
    for i = 1:numel(cells)
        cxs = xs(ids == cells(i));
        cys = ys(ids == cells(i)); 
        l = 0;
        for j = 1:numel(cxs)-1
            l = l + sqrt((cxs(j+1)-cxs(j))^2+(cys(j+1)-cys(j))^2);
        end
        l2 = sqrt((cxs(end)-cxs(1))^2+(cys(end)-cys(1))^2);
        lengths = [lengths; l/l2];
    end
end