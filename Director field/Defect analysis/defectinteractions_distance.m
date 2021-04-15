function [ppr,pnr,nnr,dr] = defectinteractions_distance(datapath)
    addpath('../');
    fpaths = getfold(datapath);
    
    ppr = [];
    nnr = [];
    pnr = [];
    
    for f = 1:numel(fpaths)
        fpath = fpaths{f};
        load([fpath 'adefs.mat'],'adefs');
        tts = unique([adefs.ts]);
        for tt = 1:numel(tts)
            t = tts(tt);
            cdefs = adefs([adefs.ts]==t);
            dxs = [cdefs.x] - [cdefs.x]';
            dys = [cdefs.y] - [cdefs.y]';
            drs = triu(sqrt(dxs.^2+dys.^2),1);
            dq = [cdefs.q] + [cdefs.q]';
            ppr = [ppr; drs(dq==1)];
            pnr = [pnr; drs(dq==0)];
            nnr = [nnr; drs(dq==-1)];
        end
    end
    ppr(ppr<13) = [];
    pnr(pnr<13) = [];
    nnr(nnr<13) = [];
    %% Plots
    x = randi(1024,5000);
    y = randi(768,5000);
    dx = x - x';
    dy = y - y';
    dr = sqrt(dx.^2+dy.^2);
    
    eds = 0:5:1182;
    
    ppgr = histcounts(ppr,eds,'Normalization','probability');
    pngr = histcounts(pnr,eds,'Normalization','probability');
    nngr = histcounts(nnr,eds,'Normalization','probability');
    normgr = histcounts(dr,eds,'Normalization','probability');
    
    ppys = (-log(ppgr./normgr));
    pnys = (-log(pngr./normgr));
    nnys = (-log(nngr./normgr));
    
    
    XYcal = getXYcal(fpath);
    plot(XYcal*(eds(2:end)-5),ppys,'r','LineWidth',2)
    hold on
    plot(XYcal*(eds(2:end)-5),pnys,'Color',[0.8 0 0.8],'LineWidth',2)
    plot(XYcal*(eds(2:end)-5),nnys,'b','LineWidth',2)
    plot([0 100],[0 0],'k--','LineWidth',1.5)
    xlim([0 30])
    set(gca,'FontSize',12,'LineWidth',2);
    xticklabels([])
    yticklabels([])
    
%     xlabel('Distance (\mum)');
%     ylabel('U(r) = -ln g(r)')
    
end