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
        
        im = real2rgb(h,myxocmap,[0 1]);
        fr = tandscalebartext(fpath,t,im);
        writeVideo(v, fr);
    end
    close(v);
end
    