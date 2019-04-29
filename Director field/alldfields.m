function alldfields(datapath)
    n = 13;
    
    fpath = [uigetdir(datapath) '/'];
    
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
        dfield(fpath,t,n);
    end
    
end
