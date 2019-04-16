function Layeranddefvid(fpath)
    files = dir([fpath '/analysis/manuallayers/']);
    dirFlags = [files.isdir];
    lfiles = files(~dirFlags);
    N = numel(lfiles);
    
    addpath('../Director field/');
    f = figure('Units','pixels','Position',[0 0 1024 768],'PaperUnits','points',...
        'PaperSize',[1024 768],'visible','off');
    ax = axes(f,'Units','pixels','Position',[0 0 1024 768]);

    [xt, yt, qt, dt, ttt, tst, idt] = alldefects(fpath);
    
    [a,b] = histcounts(idt,'BinMethod','integer');
    b = b(2:end)-0.5;
    
    ids = b(a>10);
    ids = ismember(idt,ids);
    
    x = xt(ids);
    y = yt(ids);
    q = qt(ids);
    d = dt(ids,:);
    tt = ttt(ids);
    ts = tst(ids);
    id = idt(ids);
    
    v = VideoWriter([fpath 'layervidwdef.mp4'],'MPEG-4');
    v.Quality = 95;
    v.FrameRate = 30;
    open(v);
    axes(ax);

    for t = 1:N
        l = laserdata(fpath,t);
        lsh = imsharpen(l,'Radius',3,'Amount',3);
        lsh = (lsh-min(lsh(:)))./max(lsh(:)-min(lsh(:)));
        im = real2rgb(lsh,gray);
        lays = loaddata(fpath,t,'manuallayers','int8');
        ed = edge(lays);
        ed = imdilate(ed,strel('disk',3));
        ed(lays==0) = 1;
        
        im = real2rgb(lays,myxocmap,[0 2]);
        im(:,:,1) = lsh.*im(:,:,1);
        im(:,:,2) = lsh.*im(:,:,2);
        im(:,:,3) = lsh.*im(:,:,3);
        cla;
        imshow(im);
        hold on
        ct = ts == t;
        cx = x(ct);
        cy = y(ct);
%         inds = sub2ind(size(holes),cy,cx);
%         noo = holes(inds);
        cd = d(ct,:);
        cq = q(ct);
%         
%         cx(noo) = [];
%         cy(noo) = [];
%         cd(noo,:) = [];
%         cq(noo) = [];
        
        plot(cx(cq>0),cy(cq>0),'r.','MarkerSize',30);
        plot(cx(cq<0),cy(cq<0),'.','MarkerSize',35,'Color',[0 1 1]);
        plot(cx(cq<0),cy(cq<0),'.','MarkerSize',30,'Color',[0 0 1]);
        
        quiver(cx(cq>0),cy(cq>0),20*cd(cq>0,1),20*cd(cq>0,2),'Color','r','ShowArrowHead','off','LineWidth',2,'AutoScale','off');

        
        fr = getframe(f);
        fr = fr.cdata;
        tandscalebartext(fpath,t,fr);
        writeVideo(v, fr);
    end
    close(v);
end
