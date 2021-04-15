function slvid(fpath)
    addpath('/Users/kcopenhagen/Documents/MATLAB/gitstuff/Monolayer/Figures');
    v = VideoWriter([fpath 'SLVid.mp4'],'MPEG-4');
    v.Quality = 95;
    v.FrameRate = 30;
    open(v);
    
    ts = getts(fpath);
    
%     dfields = loaddata(fpath,1,'dfield','float');
%     for t = 1:numel(ts)
%         dfields = concatenate(3,dfields,loaddata(fpath,t,'dfield','float'));
%     end
%     dfields = imgaussfilt3(dfields,[0 0 1]);
%     
    for t = 1:numel(ts)
        dfield = loaddata(fpath,t,'dfield','float');
        im = SLplotgrid(dfield,20,60);
        %im = imdilate(im,strel('disk',1));
        im = abs(im-1);
        writeVideo(v, im);
    end
    close(v)
end