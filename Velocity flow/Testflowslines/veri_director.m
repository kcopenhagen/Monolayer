function dir_err = veri_director()
%Returns an array of the difference in angle between the vector along the
%cell spline and the calculated director field at the center of each spline
%segment.
files = dir('/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Labeledflows/*mat');
dir_err = [];
for f = 1:numel(files)
    load([files(f).folder '/' files(f).name ],'p0s','p1s','p2s','ids');
    temp = strsplit(files(f).name,'t');

    folder = temp{1};
    folder = folder(6:end);

    t = temp{2};
    t = strsplit(t,'.');
    t = str2num(t{1});

    fpath = [fileparts(files(f).folder) '/Data/' folder '/'];

%------------------------------------------------------------------------%
    dfield = loaddata(fpath,t-1,'dfield','float');
    
    sz = size(dfield);
    xs = p0s(:,1);
    ys = p0s(:,2);
    
    cells = unique(ids);
    for i = 1:numel(cells)
        cxs = xs(ids == cells(i));
        cys = ys(ids == cells(i));
        for j = 1:numel(cxs)-1
            x_cent = (cxs(j+1)+cxs(j))/2;
            y_cent = (cys(j+1)+cys(j))/2;
            
            inds = sub2ind(sz,round(y_cent),round(x_cent));
            
            cds = dfield(inds);
            cdx = cos(cds);
            cdy = sin(cds);
            
            lds = atan((cys(j+1)-cys(j))/(cxs(j+1)-cxs(j)));
            ldx = cos(lds);
            ldy = sin(lds);
            
            dir_err = [dir_err; acos(cdx*ldx+cdy*ldy)];
            
        end
    end
%------------------------------------------------------------------------%
    dfield = loaddata(fpath,t,'dfield','float');
    
    sz = size(dfield);
    xs = p1s(:,1);
    ys = p1s(:,2);
    
    cells = unique(ids);
    for i = 1:numel(cells)
        cxs = xs(ids == cells(i));
        cys = ys(ids == cells(i));
        for j = 1:numel(cxs)-1
            x_cent = (cxs(j+1)+cxs(j))/2;
            y_cent = (cys(j+1)+cys(j))/2;
            
            inds = sub2ind(sz,round(y_cent),round(x_cent));
            
            cds = dfield(inds);
            cdx = cos(cds);
            cdy = sin(cds);
            
            lds = atan((cys(j+1)-cys(j))/(cxs(j+1)-cxs(j)));
            ldx = cos(lds);
            ldy = sin(lds);
            
            dir_err = [dir_err; acos(cdx*ldx+cdy*ldy)];
            
        end
    end
%------------------------------------------------------------------------%
    dfield = loaddata(fpath,t+1,'dfield','float');
    
    sz = size(dfield);
    xs = p2s(:,1);
    ys = p2s(:,2);
    
    cells = unique(ids);
    for i = 1:numel(cells)
        cxs = xs(ids == cells(i));
        cys = ys(ids == cells(i));
        for j = 1:numel(cxs)-1
            x_cent = (cxs(j+1)+cxs(j))/2;
            y_cent = (cys(j+1)+cys(j))/2;
            
            inds = sub2ind(sz,round(y_cent),round(x_cent));
            
            cds = dfield(inds);
            cdx = cos(cds);
            cdy = sin(cds);
            
            lds = atan((cys(j+1)-cys(j))/(cxs(j+1)-cxs(j)));
            ldx = cos(lds);
            ldy = sin(lds);
            
            dir_err = [dir_err; acos(cdx*ldx+cdy*ldy)];
            
        end
    end
end
    