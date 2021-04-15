function numbers(datapath)
    fpaths = getfold(datapath);
    for f = 1:numel(fpaths)
        load([fpaths{f} 'adefs.mat'],'adefs');
        totp = 0;
        totn = 0;
        for i = 1:numel(adefs)
            if adefs(i).q>0
                totp = totp+1;
            else
                totn = totn+1;
            end
        end
        fprintf('f = %d, pos = %d, neg = %d\n',f, totp, totn)
        
    end