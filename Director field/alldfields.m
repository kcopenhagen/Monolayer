function alldfields(datapath)

    % Goes through all experiments in the datapath folder and calculates
    % the director field and saves it for all of them using the dfield
    % function.
    
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
