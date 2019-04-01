function XYcal = getXYcal(fpath)
    %Returns the laser, and height data from path fpath, at time point t. 
    %As well as the time at which the data was taken.
    %Will return NaN if t is beyond the last time point.

    info = fileread([fpath '/info.txt']);
    info = strsplit(info,'\n');
    Key = 'XY Calibration:';
    calind = cellfun(@(s) contains(s,Key),info);
    Str = info{calind};
    Index = strfind(Str, Key);
    XYcal = sscanf(Str(Index(1) + length(Key):end), '%g', 1);

end
