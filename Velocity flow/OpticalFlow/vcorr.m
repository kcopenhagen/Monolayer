function vcorr(datapath)
%% Calculate and plot velocity correlation function vs. r. Fit to find correlation length.

    fpaths = getfold(datapath);
    vcorrs = [];
    vvs = [];
    drs = [];
    for f = 1:numel(fpaths)
        fpath = fpaths{f};
        XYcal = getXYcal(fpath);
        ts = getts(fpath);
        for t = 1:numel(ts)
            vxs = loaddata(fpath,t,'flows/Vx','float');
            vys = loaddata(fpath,t,'flows/Vy','float');
            xs = XYcal*(1:numel(vxs(1,:)));
            ys = XYcal*(1:numel(vxs(:,1)));
            [xs,ys] = meshgrid(xs,ys);
            vxs = vxs(:);
            mvx = mean(vxs);
            vxs = vxs-mvx;
            vys = vys(:);
            mvy = mean(vys);
            vys = vys-mvy;
            xs = xs(:);
            ys = ys(:);
            pt1s = randi(numel(vxs),[10000 1]);
            pt2s = randi(numel(vxs),size(pt1s));
            vcorrs = [vcorrs; (vxs(pt1s).*vxs(pt2s)+vys(pt1s).*vys(pt2s))];
            vvs = [vvs; (vxs(pt1s).^2+vys(pt1s).^2);(vxs(pt2s).^2+vys(pt2s).^2)];
            drs = [drs; sqrt((xs(pt2s)-xs(pt1s)).^2+(ys(pt2s)-ys(pt1s)).^2)];
        end
    end
    
    %% Bin and average the correlations then plot that.
    
    subs = round(2*drs)+1;
    
    av = mean(vvs);
    adc = accumarray(subs,(vcorrs)/av,[],@mean);
    adcerr = accumarray(subs,vcorrs/av,[],@std);
    n = accumarray(subs,ones(size(vcorrs)),[],@sum);
    ars = accumarray(subs,drs,[],@mean);

    XYcal = getXYcal(fpath);
    %plot(((unique(subs)-1)/2),adc/av,'k','LineWidth',2);
    errorbar(ars,adc,adcerr./sqrt(n),'k.','LineWidth',2);
    
    hold on
%     l = (find(abs(adc/av-0.5)==min(abs(adc/av-0.5)))-1)/2
%     plot([l l],[0 0.5],'k--')
%     plot([0 l],[0.5 0.5],'k--')
    plot(ars,exp(-(1/3.9)*ars),'r--','LineWidth',2)
    set(gca,'FontSize',12,'LineWidth',2)
    hold on
    
    xlim([0 90])
    xticks([0 25 50 75])
    xticklabels([])
    ylim([0 1])
    yticks([0 0.5 1])
    yticklabels([])
end