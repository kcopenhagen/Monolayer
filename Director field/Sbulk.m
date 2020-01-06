function Sbulk(datapath)
%% Calculating average local order parameter in the bulk of the monolayer.
    fpaths = getfold(datapath);
    meanS = [];
    rs = 0.1:0.1:1;
    eds = 0:0.02:1;
    for r = rs
        r
        avavs = [];
        for f = 1:numel(fpaths)
            f
            fpath = fpaths{f};
            XYcal = getXYcal(fpath);
            ts = getts(fpath);
            avs = [];
            for t = 1:10:numel(ts)-1
                S = findS(fpath,t,r);
                avs = [avs; S(:)];
            end
            avavs = [avavs; avs];
%             figure(f)
%             hold on
%             h = histcounts(avs,eds);
%             plot((eds(2:end)-eds(2)/2),h);
%             drawnow
        end
        meanS = [meanS; mean(avavs)];
    end
    
    figure
    plot(rs,meanS);
end