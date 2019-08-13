function ts = getts(fpath)
    fid = fopen([fpath 'times.txt']);
    ts = fscanf(fid,'%f');
    fclose(fid);
    files = dir([fpath 'Laser/']);
    dF = [files.isdir];
    files = files(~dF);
    ts = ts(1:numel(files));

end