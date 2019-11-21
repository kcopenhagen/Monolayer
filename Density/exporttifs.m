fpaths = getfold(datapath);
for f = 1:numel(fpaths)
    %%
    fpath = fpaths{f};
    [~,~,~] = mkdir([fpath 'analysis/l_tiffs']);
    ts = getts(fpath);
    for t = 1:numel(ts)
        l = laserdata(fpath,t);
        l = l./imgaussfilt(l,64)/2;
        name = sprintf('%06d.tiff',t-1);
        imwrite(l,[fpath 'analysis/l_tiffs/' name],'TIFF');
    end
    
end