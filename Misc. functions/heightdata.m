function h = heightdata(fpath, t)
    %Returns the laser, and height data from path fpath, at time point t. 
    %As well as the time at which the data was taken.
    %Will return NaN if t is beyond the last time point.
    
    info = fileread([fpath '/info.txt']);
    info = strsplit(info,'\n');

    Key = 'Z Calibration:';
    calind = cellfun(@(s) contains(s,Key),info);
    Str = info{calind};
    Index = strfind(Str, Key);
    Zcal = sscanf(Str(Index(1) + length(Key):end), '%g', 1);

    name = sprintf('%06d.bin',t-1);

    fname = [fpath '/Height/' name];
    fid = fopen(fname);
    im = fread(fid,[1024 768],'int');
    h = Zcal * transpose(im);
    fclose(fid);
    
end
