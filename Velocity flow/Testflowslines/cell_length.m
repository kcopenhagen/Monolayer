function lengths = cell_length

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
        lengths = [lengths; l*XYcal];
    end
end