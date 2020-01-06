function Svid(datapath)

    if nargin>0
        fpath = [uigetdir(datapath) '/'];
    else
        fpath = [uigetdir '/'];
    end

    v = VideoWriter([fpath 'Svid.mp4'],'MPEG-4');
    v.Quality = 95;
    v.FrameRate = 30;
    open(v);
    XYcal = getXYcal(fpath);
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
    
    xs = 1024-(63:264);
    ys = 768-(193:344);
    
    for t = 10:N
%%
        l = laserdata(fpath, t);
        l = l./imgaussfilt(l,64);
        l = normalise(l);
        %l = imsharpen(l,'Amount',3,'Radius',3);
        %l = normalise(l);
        l = l(ys,xs);
        S = loaddata(fpath,t,'order','float');
        S = S(ys,xs);
        
        dfield = loaddata(fpath,t,'dfield','float');
        dfield = dfield(ys,xs);
        load('../Figures/orientcmap.mat');
        % Orientation video.
        %im = real2rgb(dfield,orientcmap);
        %im(:,:,1) = 2*l.*im(:,:,1);
        %im(:,:,2) = 2*l.*im(:,:,2);
        %im(:,:,3) = 2*l.*im(:,:,3);
        %im(im>1) = 1;
        
        % Laser video.
        %im = real2rgb(S,gray);
        
        % Order video.
        im = real2rgb(S,colorcet('L6'));
        
        fid = fopen([fpath 'times.txt']);
        times = fscanf(fid,'%f');
        fclose(fid);
        tt = times(t);
        
        I = textborderim(im,10,5,[sprintf('%1.1f',tt/(60*60)) 'hrs'],24);
        I(280:285,210:(210+round(10/XYcal)),:) = zeros(6,76,3);
        I(282:283,212:(208+round(10/XYcal)),:) = ones(2,72,3);
        I = textborderim(I,215,245,['10' sprintf('%s',char(956)) 'm'],20); 
        %I = im;
        writeVideo(v, I);
    end
    close(v);
    
end
    