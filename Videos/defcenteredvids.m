fpaths = getfold(datapath);

%%
for f = 1:numel(fpaths)
    fpath = fpaths{f};
    load([fpath 'adefs.mat'],'adefs');
    [a, b] = histcounts([adefs.id],'BinMethod','integer');
    adefs = adefs(ismember([adefs.id],b(a>50)+1/2));
    ids = unique([adefs.id]);
    
    %%
    for i = 1:numel(ids)
        sz = 200;
        fig = figure('Visible','off','Units','pixels','Position',[0 0 sz sz]);
        ax = axes(fig,'Position',[0 0 1 1]);
        id = ids(i);
        cdefs = adefs([adefs.id] == id);
        F = struct('colormap',[],'cdata',[]);
        dr = [0 0];
        for t = 1:numel(cdefs)

            l = laserdata(fpath,cdefs(t).ts);
            l = l./imgaussfilt(l,64);
            l = normalise(l);
            lb = l;
            l = padarray(l,[500 500],NaN,'both');

            xlims = [cdefs(t).x+500-sz/2, cdefs(t).x+500+sz/2];
            ylims = [cdefs(t).y+500-sz/2, cdefs(t).y+500+sz/2];
            
            l = l(ylims(1):ylims(2),xlims(1):xlims(2));
            if t==1
                lo = lb;
                h = xcorr_fft(lo,lb);
                p0 = xcorrpeak(h);
            else
                h = xcorr_fft(lo,lb);
                p = xcorrpeak(h);
                dr = [0 0 ];%[p(1)-p0(1) p(2)-p0(2)];
            end
            
            
            imagesc(ax,l)
            colormap gray


            xlims = get(ax,'xlim')+dr(1);
            ylims = get(ax,'ylim')+dr(2);
            xlims = [xlims(1)+10 xlims(2)-10];
            ylims = [ylims(1)+10 ylims(2)-10];
            xlim(xlims);
            ylim(ylims);
            hold on
            if cdefs(t).q>0
                plot((sz-1)/2,(sz-1)/2,'r.','MarkerSize',10)
                plot([(sz-1)/2 (sz-1)/2+10*cdefs(t).d(1)],...
                    [(sz-1)/2 (sz-1)/2+10*cdefs(t).d(2)],'r','LineWidth',1.5);
            else
                plot((sz-1)/2,(sz-1)/2,'b.','MarkerSize',10)
                theta = atan2(cdefs(t).d(2),cdefs(t).d(1));
                d = [cos(theta) sin(theta)];
                plot([(sz-1)/2 (sz-1)/2+10*d(1)],...
                    [(sz-1)/2 (sz-1)/2+10*d(2)],'b','LineWidth',1.5);
                theta = theta+2*pi/3;
                d = [cos(theta) sin(theta)];
                plot([(sz-1)/2 (sz-1)/2+10*d(1)],...
                    [(sz-1)/2 (sz-1)/2+10*d(2)],'b','LineWidth',1.5);
                theta = theta+2*pi/3;
                d = [cos(theta) sin(theta)];
                plot([(sz-1)/2 (sz-1)/2+10*d(1)],...
                    [(sz-1)/2 (sz-1)/2+10*d(2)],'b','LineWidth',1.5);
            end
            hold off
            F(t) = getframe(fig);
            lo = lb;
        end
        playmovie(F);
        keyboard
        close all
        
    end
    
end