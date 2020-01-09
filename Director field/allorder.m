function allorder(datapath)

    fpaths = getfold(datapath);
    for f = 1:numel(fpaths)
        fpath = fpaths{f};
        files = dir([fpath '/Laser/']);
        dirFlags = [files.isdir];
        files(dirFlags) = [];
        del = [];
        for t = 1:numel(files)
            if files(t).name(1) == '.'
                del = [del; t];
            end
        end
        files(del) = [];

        N = numel(files);
        for t = 1:N
            nemorderfield(fpath,t);
        end
    end
end
