function Layervid(fpath)
    files = dir([fpath '/analysis/manuallayers/']);
    dirFlags = [files.isdir];
    lfiles = files(~dirFlags);
    N = numel(lfiles);
    
    v = VideoWriter([fpath 'layervid.mp4'],'MPEG-4');
    v.Quality = 95;
    v.FrameRate = 30;
    open(v);
    for t = 1:N
        l = laserdata(fpath,t);
        lsh = imsharpen(l,'Radius',3,'Amount',3);
        lsh = (lsh-min(lsh(:)))./max(lsh(:)-min(lsh(:)));
        im = real2rgb(lsh,gray);
        lays = loaddata(fpath,t,'manuallayers','int8');
        ed = edge(lays);
        ed = imdilate(ed,strel('disk',3));
        ed(lays==0) = 1;
        
        im = real2rgb(lays,colorcet('R2'),[0 2]);
        im(:,:,1) = lsh.*im(:,:,1);
        im(:,:,2) = lsh.*im(:,:,2);
        im(:,:,3) = lsh.*im(:,:,3);
        writeVideo(v,im);
    end
    close(v);
end
