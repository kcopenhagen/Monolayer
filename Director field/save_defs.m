function save_defs(datapath)
%% Find ad track defects and then save them into a .mat file for future use.
    fpaths = getfold(datapath);
    for f = 1:numel(fpaths)
        f
        fpath = fpaths{f};
        adefs = alldefects(fpath);
        save([fpath 'adefs.mat'],'adefs');
    end
    