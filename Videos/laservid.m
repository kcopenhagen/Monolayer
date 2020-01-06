function laservid(datapath)

    if nargin>0
        fpath = [uigetdir(datapath) '/'];
    else
        fpath = [uigetdir '/'];
    end

    v = VideoWriter([fpath 'laservid.mp4'],'MPEG-4');
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

        l = laserdata(fpath, t);
        l = l./imgaussfilt(l,64);
        l = normalise(l);
        
        im = real2rgb(l,gray);
        fr = tandscalebartext(fpath,t,im);
        writeVideo(v, fr);
    end
    close(v);
    
end
    