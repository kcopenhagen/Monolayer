function medianlayers(fpath)
    [~,~,~] = mkdir([fpath 'analysis/mlays/']);
    files = dir([fpath 'analysis/layers/']);
    dirFlags= [files.isdir];
    layfiles = files(~dirFlags);
    N = numel(layfiles);
    n = 2;
    alay = NaN(768,1024,2*n+1);
    for t = 1:N+2*n+1
        try
            layst = loaddata(fpath,t,'Layers','int8');
        catch
            layst = NaN(768,1024);
        end
        alay(:,:,end) = layst;
        
        tt = t-n;
        if (tt>=1 && tt<=N)
            lay = nanmedian(alay,3);
            lay = round(imgaussfilt(lay,1));
            fid = fopen([fpath '/analysis/mlays/' sprintf('%06d.bin',tt-1)],'w');
            fwrite(fid,lay,'int8');
            fclose(fid);
        end
        
        for i = 1:2*n
            alay(:,:,i) = alay(:,:,i+1);
        end
    end