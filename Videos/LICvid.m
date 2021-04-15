function LICvid(fpath)
    v = VideoWriter([fpath 'LICVid.mp4'],'MPEG-4');
    v.Quality = 95;
    v.FrameRate = 30;
    open(v);
    
    ts = getts(fpath);

    for t = 1:150
        
        LIC = loaddata(fpath,t,'LICim','float');
        LIC = (LIC-0.2)/0.6;
        LIC(LIC<0) = 0;
        LIC(LIC>1) = 1;
        im = LIC;
        holes = loaddata(fpath,t,'covid_layers','int8');
        im(holes==0) = 0;
        writeVideo(v, im);
    end
    close(v)