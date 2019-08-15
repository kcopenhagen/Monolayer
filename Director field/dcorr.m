function dcorr(datapath)
%%
    fpaths = getfold(datapath);
    dcorrs = [];
    drs = [];
    for f = 1:numel(fpaths)
        fpath = fpaths{f};
        XYcal = getXYcal(fpath);
        ts = getts(fpath);
        for t = 1:numel(ts)
            dfield = loaddata(fpath,t,'dfield','float');
            dxs = cos(dfield);
            dxs = dxs(:);
            dys = sin(dfield);
            dys = dys(:);
            xs = XYcal*(1:numel(dfield(1,:)));
            ys = XYcal*(1:numel(dfield(:,1)));
            [xs,ys] = meshgrid(xs,ys);
            xs = xs(:);
            ys = ys(:);
            pt1s = randi(numel(dxs),[10000 1]);
            pt2s = randi(numel(dxs),size(pt1s));
            dcorrs = [dcorrs; 2*(dxs(pt1s).*dxs(pt2s)+dys(pt1s).*dys(pt2s))-1];
            drs = [drs; sqrt((xs(pt2s)-xs(pt1s)).^2+(ys(pt2s)-ys(pt1s)).^2)];
        end
    end
    
    %% Bin and average the correlations then plot that.
    
    subs = round(drs)+1;
    adc = accumarray(subs,(dcorrs),[],@mean);
    XYcal = getXYcal(fpath);
    plot((unique(subs)-1),adc,'k','LineWidth',2);
    hold on
    plot([8 8],[0 0.5],'k--')
    plot([0 8],[0.5 0.5],'k--')
    set(gca,'FontSize',12);
    xlim([0 100])
    xlabel('Distance (R {\mu}m)');
    ylabel('2{\langle}d(R) \cdot d(0){\rangle} - 1');
end