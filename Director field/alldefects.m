function adefs = alldefects(fpath)
    
    files = dir([fpath 'analysis/manuallayers/']);
    dirFlags = [files.isdir];
    files = files(~dirFlags);

    del = [];
    for i = 1:numel(files)
        if files(i).name(1) == '.'
            del = [del; i];
        end
    end
    files(del) = [];
    
    N = numel(files);
    
    fid = fopen([fpath 'times.txt']);
    times = fscanf(fid,'%f');
    fclose(fid);
    x = [];
    y = [];
    q = [];
    d = [];
    tt = [];
    id = [];
    ts = [];
    iso = [];
    
    for t = 1:N
        defs = finddefects(fpath,t);
        xt = [defs.x];
        yt = [defs.y];
        qt = [defs.q];
        isot = [defs.iso];
        
        dt = zeros(numel(xt),2);
        dtt = [defs.d];
        dt(:,1) = dtt(1:2:end-1);
        dt(:,2) = dtt(2:2:end);
        x = [x; xt'];
        y = [y; yt'];
        iso = [iso; isot'];
        q = [q; qt'];
        d = [d; dt];
        tt = [tt; times(t)*ones(numel(xt),1)];
        id = [id; -1*ones(numel(xt),1)];
        ts = [ts; t*ones(numel(xt),1)];
        
    end
    
    lab = 1;
    i = find(id==-1,1);
    while ~isempty(i)
        id(i)=lab;
        
        dt = ts - ts(i);
        dx = x-x(i);
        dy = y-y(i);
        dr = sqrt(dx.^2+dy.^2);
        dq = q(i)-q;
        tp1 = (abs(dq)<0.1).*(dt==1)==1;
        inds = 1:numel(tp1);
        inds = inds(tp1);
        
        [mdr,ind] = min(dr(tp1));
        
        j = inds(ind);
        
        if j
            dt = ts - ts(j);
            dx = x - x(j);
            dy = y - y(j);
            dr = sqrt(dx.^2+dy.^2);
            dq = q(i) - q;
            tp1 = (abs(dq)<0.1).*(dt==-1)==1;
            inds = 1:numel(tp1);
            inds = inds(tp1);

            [~,ind] = min(dr(tp1));
        
            if inds(ind) == i && mdr < 20
                
                i = j;
            else 
                i = find(id==-1,1);
                lab = lab+1;
            end
        else 
            i = find(id==-1,1);
            lab = lab+1;
        end
        
    end
    [a,b] = histcounts(id,'BinMethod','integer');
    ids = b+0.5;
    ids(a<10) = [];
    good = ismember(id,ids);
    adefs = struct('x',num2cell(x),'y',num2cell(y),'q',num2cell(q),...
        'd',num2cell(d,2),'tt',num2cell(tt),'ts',num2cell(ts),...
        'id',num2cell(id),'iso',num2cell(iso));
    adefs = adefs(good);
end



