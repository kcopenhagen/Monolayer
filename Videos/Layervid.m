function Layervid(datapath)
    if nargin>0
        fpath = [uigetdir(datapath) '/'];
    else
        fpath = [uigetdir '/'];
    end
    files = dir([fpath 'analysis/manuallayers/']);
    dirFlags = [files.isdir];
    lfiles = files(~dirFlags);
    N = numel(lfiles);
    
    v = VideoWriter([fpath 'layervid.mp4'],'MPEG-4');
    v.Quality = 95;
    v.FrameRate = 30;
    open(v);
    
    for t = 1:N
        l = laserdata(fpath,t);
        l = l./imgaussfilt(l,64);
        l = normalise(l);
        lays = loaddata(fpath,t,'manuallayers','int8');

        im = real2rgb(lays,myxocmap,[0 2]);
        im(:,:,1) = l.*im(:,:,1)*1.6;
        im(:,:,2) = l.*im(:,:,2)*1.6;
        im(:,:,3) = l.*im(:,:,3)*1.6;
        im(im>1) = 1;
        fr = tandscalebartext(fpath,t,im);
        writeVideo(v,fr);
        
    end
    close(v);
end
