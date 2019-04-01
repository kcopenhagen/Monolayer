function data = loaddata(fpath, t, dataname, datatype)

    [l, h, tt, XYcal, name] = rawdata(fpath, t);
    fID = fopen([fpath '/analysis/' dataname '/' name],'r');
    data = fread(fID, [768 1024], datatype);
    fclose(fID);
    
end