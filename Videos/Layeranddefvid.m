function Layeranddefvid(fpath)
    if nargin>0
        fpath = fpath;
    else
        fpath = [uigetdir '/'];
    end
    
    
    v = VideoWriter([fpath 'Layerswithdefvid.mp4'],'MPEG-4');
    v.Quality = 95;
    v.FrameRate = 12;
    open(v);
    
    f = figure('Units','pixels','Position',[0 0 1024/2 768/2],'PaperUnits','points',...
        'PaperSize',[1024/2 768/2],'visible','off');
    ax = axes(f,'Units','pixels','Position',[0 0 1024/2 768/2]);
    
    files = getts(fpath);
    
    N = numel(files);
    l1 = laserdata(fpath,1);
    l1 = l1./imgaussfilt(l1,64);
    l1 = 3*normalise(l1)-0.4;
    meanl1 = mean(l1,'all');
    
    %adefs = alldefects(fpath);
    for t = 1:N
        axes(ax);
        cla(ax);
        l = laserdata(fpath,t);
        l = l./imgaussfilt(l,64);
        l = 3*normalise(l)-0.4;
        meanl = mean(l,'all');
        l = l - (meanl - meanl1);
        lays = loaddata(fpath,t,'covid_layers','int8');

        im = real2rgb(lays,flipud(myxocmap),[0 2]);
        imr = im(:,:,1);
        img = im(:,:,2);
        imb = im(:,:,3);
        imr = imr.*l;
        img = img.*l;
        imb = imb.*l;
        im(:,:,1) = imr;
        im(:,:,2) = img;
        im(:,:,3) = imb;
        imshow(im)
        axis off

        colormap gray
        caxis([0.7 1.3])

        hold on
        defs = load([fpath 'adefs.mat']);

        defs = defs.adefs;
        cdefs = defs([defs.ts]==t);
        l = 35;
        lw = 6;
        ms = 45;
        ncol = [0 115 178]/255;
        pcol = [230 31 15]/255;
        ncolrim = ncol;
        pcolrim = pcol;
        % ncolrim = [0.5 0.9 1];
        % pcolrim = [1 0.9 0.5];

        for i = 1:numel(cdefs)
            if cdefs(i).q>0
                plot(cdefs(i).x,cdefs(i).y,'.','MarkerSize',ms,'Color',pcolrim)
                plot([cdefs(i).x cdefs(i).x+l*cdefs(i).d(1),...
                    cdefs(i).x],...
                    [cdefs(i).y cdefs(i).y+l*cdefs(i).d(2),...
                    cdefs(i).y],'LineWidth',lw,'Color',pcolrim);
        %         plot(cdefs(i).x,cdefs(i).y,'.','MarkerSize',30,'Color',pcol)
        %         plot([cdefs(i).x cdefs(i).x+l*cdefs(i).d(1),...
        %             cdefs(i).x],...
        %             [cdefs(i).y cdefs(i).y+l*cdefs(i).d(2),...
        %             cdefs(i).y],'LineWidth',4,'Color',pcol);
            else
                plot(cdefs(i).x,cdefs(i).y,'.','MarkerSize',ms,'Color',ncolrim)
                theta = atan2(cdefs(i).d(2),cdefs(i).d(1));
                plot([cdefs(i).x cdefs(i).x+l*cos(theta) ...
                    cdefs(i).x cdefs(i).x+l*cos(theta+2*pi/3) ...
                    cdefs(i).x cdefs(i).x+l*cos(theta+4*pi/3),...
                    cdefs(i).x],...
                    [cdefs(i).y cdefs(i).y+l*sin(theta)...
                    cdefs(i).y cdefs(i).y+l*sin(theta+2*pi/3)...
                    cdefs(i).y cdefs(i).y+l*sin(theta+4*pi/3),...
                    cdefs(i).y],...
                    'Color',ncolrim,'LineWidth',lw);
        % 
        %         plot(cdefs(i).x,cdefs(i).y,'.','MarkerSize',30,'Color',ncol)
        %         plot([cdefs(i).x cdefs(i).x+l*cos(theta) ...
        %             cdefs(i).x cdefs(i).x+l*cos(theta+2*pi/3) ...
        %             cdefs(i).x cdefs(i).x+l*cos(theta+4*pi/3),...
        %             cdefs(i).x],...
        %             [cdefs(i).y cdefs(i).y+l*sin(theta)...
        %             cdefs(i).y cdefs(i).y+l*sin(theta+2*pi/3)...
        %             cdefs(i).y cdefs(i).y+l*sin(theta+4*pi/3),...
        %             cdefs(i).y],...
        %             'Color',ncol,'LineWidth',4);
            end
        end

        set(ax,'XDir','normal');
        set(ax,'YDir','reverse');

        F = getframe(f);
        fr = tandscalebartext(fpath,t,F.cdata);
        %fr = imresize(fr,0.5);
        fname = sprintf('images/%d.png',t-1);
        imwrite(fr,fname);
%        writeVideo(v, fr);

    end
    close(f)
    close(v);

end
    