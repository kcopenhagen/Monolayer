function fpaths = getfold(datapath)
folders = dir(datapath);
dF = [folders.isdir];
folders = folders(dF);
del = [];
for f = 1:numel(folders)
    if folders(f).name(1) == '.'
        del = [del; f];
    end
end

folders(del) = [];
for f = 1:numel(folders)
    fpaths{f} = [folders(f).folder '/' folders(f).name '/'];
end
end