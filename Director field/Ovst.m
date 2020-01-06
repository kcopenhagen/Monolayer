%% Calculate order parameter of entire frame for each experiment and plot it vs. time.
fpaths = getfold(datapath);
figure
hold(gca,'on');
for f = 1:numel(fpaths)
    
    fpath = fpaths{f};
    
    ts = getts(fpath);
    O = [];
    for t = 1:numel(ts)
        
        dfield = loaddata(fpath,t,'dfield','float');
        m2dx = mean(cos(dfield*2),'all');
        m2dy = mean(sin(dfield*2),'all');
        mdfield = atan2(m2dy,m2dx)/2;
        
        mdx = cos(mdfield);
        mdy = sin(mdfield);
        
        dx = cos(dfield);
        dy = sin(dfield);
        
        costhm = mdx*dx+mdy*dy;
        
        O = [O; mean(2*costhm.^2-1,'all')];
        
        
    end
    plot(ts,O,'LineWidth',2);
    
end