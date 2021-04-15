function heightvid(datapath)
    if nargin>0
        fpath = [uigetdir(datapath) '/'];
    else
        fpath = [uigetdir '/'];
    end
        
    v = VideoWriter([fpath 'Heightvid.mp4'],'MPEG-4');
    v.Quality = 95;
    v.FrameRate = 30;
    open(v);
    
    files = dir([fpath 'Laser/']);
    dirFlags = [files.isdir];
    files = files(~dirFlags);
    
    del = [];
    for i = 1:numel(files)
        if files(i).name(1) == '.'
            del = [del; i];
        end
    end
    files(del) = [];
    
    N = numel(files);
    
    for t = 1:N

        h = heightdata(fpath, t);
        h = h-imgaussfilt(h,64);
        h = h-min(h(:));
        
        [cts,eds] = histcounts(h(:));
        [m,i] = max(cts);
        h0 = (eds(i)+eds(i+1))/2;
        h = h-h0;
        im = real2rgb(h,flipud(myxocmap),[-0.2 0.15]);
        fr = tandscalebartext(fpath,t,im);
        writeVideo(v, fr);
    end
    close(v);
end
    