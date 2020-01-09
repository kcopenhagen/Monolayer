function dcorr(datapath)
%%
    fpaths = getfold(datapath);
    dcorrs = [];
    rxs = [];
    rys = [];
    expt = [];
    for f = 1:numel(fpaths)
        fpath = fpaths{f};
        XYcal = getXYcal(fpath);
        ts = getts(fpath);
        for t = 1:numel(ts)
            dfield = loaddata(fpath,t,'dfield','float');
            nxs = cos(2*dfield);
            nxs = nxs(:);
            nys = sin(2*dfield);
            nys = nys(:);
            xs = XYcal*(1:numel(dfield(1,:)));
            ys = XYcal*(1:numel(dfield(:,1)));
            [xs,ys] = meshgrid(xs,ys);
            xs = xs(:);
            ys = ys(:);
            pt1s = randi(numel(nxs),[10000 1]);
            pt2s = randi(numel(nxs),size(pt1s));
            dcorrs = [dcorrs; (nxs(pt1s).*nxs(pt2s)+nys(pt1s).*nys(pt2s))];
            
            rxs = [rxs; xs(pt2s)-xs(pt1s)];
            rys = [rys; ys(pt2s)-ys(pt1s)];
            expt = [expt; f*ones(size(xs(pt1s)))];
        end
    end

    %% Bin and average the correlations then plot that.
    drs = sqrt(rxs.^2+rys.^2);
    xsubs = round(rxs+1-min(rxs));
    ysubs = round(rys+1-min(rxs));
    subs = sub2ind(size(dfield),ysubs,xsubs);
    %subs = round(drs)+1;
    adc = accumarray(subs,dcorrs,[],@mean);
    axs = accumarray(subs,rxs,[],@mean);
    ays = accumarray(subs,rys,[],@mean);
    ars = accumarray(subs,drs,[],@mean);
    scatter(axs(ars<99),ays(ars<99),5,adc(ars<99));
    colorcet('R2')
    axis equal
    caxis([0 1])
    
    %% Average over angles to get C(r) = d(R).d(0)
    
    close all
    fig = figure;
    ax = axes(fig);
    drs = sqrt(rxs.^2+rys.^2);

    subs = round(drs)+1-min(drs);
    
    adc = accumarray(subs,dcorrs,[],@mean);
    adcerr = accumarray(subs,dcorrs,[],@std);
    n = accumarray(subs,ones(size(drs)),[],@sum);
    
    ars = accumarray(subs,drs,[],@mean);
    errorbar(ars,adc,(adcerr./sqrt(n)),'.k','LineWidth',2)
    %plot(ars,adc,'k','LineWidth',2)
    hold on
    plot(ars,0.2404+0.769*exp(-0.059*ars),'r--','LineWidth',2)
    set(ax,'FontSize',12,'LineWidth',2)
    hold on
    
    xlim([0 90])
    xticks([0 25 50 75])
    xticklabels([])
    ylim([0 1])
    yticks([0 0.5 1])
    yticklabels([])
    %% Plot each experiment separately.
    drs = sqrt(rxs.^2+rys.^2);

    for f = 1:numel(unique(expt))
        cdcorrs = dcorrs(expt==f);
        cdrs = drs(expt==f);
        subs = round(cdrs)+1-min(cdrs);
        
        adc = accumarray(subs,cdcorrs,[],@mean);
        adcerr = accumarray(subs,cdcorrs,[],@std);
        n = accumarray(subs,ones(size(cdrs)),[],@sum);

        ars = accumarray(subs,cdrs,[],@mean);
        errorbar(ars,adc,adcerr./sqrt(n),'.','LineWidth',2)
        hold on
    end
    xlim([0 100])
    ylim([0 1])
    
end