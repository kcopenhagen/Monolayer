function ts = getts(fpath)
    fid = fopen([fpath 'times.txt']);
    ts = fscanf(fid,'%f');
    fclose(fid);
    
    files = dir([fpath 'Laser/']);
    dF = [files.bytes]>1500000;
    files = files(dF);
    ts = ts(1:numel(files));

end