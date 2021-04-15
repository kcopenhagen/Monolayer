fpaths = getfold(datapath);
for f = 1:numel(fpaths)
    %%
    fpath = fpaths{f};
    [~,~,~] = mkdir([fpath 'analysis/h_tiffs']);
    [~,~,~] = mkdir([fpath 'analysis/l_tiffs']);

    ts = getts(fpath);
    for t = 1:numel(ts)
        l = laserdata(fpath,t);
        l = l./imgaussfilt(l,64)/2;
        l = normalise(l);
        name = sprintf('%06d.tiff',t-1);
        imwrite(l,[fpath 'analysis/l_tiffs/' name],'TIFF');
        h = heightdata(fpath,t);
        h = h - imgaussfilt(h,64);
        h = normalise(h);
        imwrite(h,[fpath 'analysis/h_tiffs/' name],'TIFF');
    end
    
end