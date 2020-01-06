function allPIVs(datapath)

folders = getfold(datapath);

for f = 1:numel(folders)
    fpath = folders{f};
    [~,~,~] = mkdir([fpath 'analysis/flows/']);
    [~,~,~] = mkdir([fpath 'analysis/flows/Vx']);
    [~,~,~] = mkdir([fpath 'analysis/flows/Vy']);
    files = dir([fpath 'Laser']);
    del = [];
    for t = 1:numel(files)
        if files(t).name(1) == '.'
            del = [del; t];
        end
    end
    files(del) = [];
    N = numel(files);
    
    for t = 1:N
        [xs,ys,vx,vy] = PIV(fpath,t,20);
        [xx,yy] = meshgrid(xs,ys);
        xq1 = 1:1024;
        yq1 = 1:768;
        [xq,yq] = meshgrid(xq1,yq1);
        vx = qinterp2(xx,yy,vx,xq,yq);
        vy = qinterp2(xx,yy,vy,xq,yq);
        
        name = sprintf('%06d.bin',t-1);
        fID = fopen([fpath '/analysis/flows/Vx/' name],'w');
        fwrite(fID,vx,'float');
        fclose(fID);
        fID = fopen([fpath '/analysis/flows/Vy/' name],'w');
        fwrite(fID,vy,'float');
        fclose(fID);
        
    end
end
        