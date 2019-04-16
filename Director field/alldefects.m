function [x,y,q,d,tt,ts,id] = alldefects(fpath)
    
    files = dir([fpath 'analysis/mlays/']);
    dirFlags = [files.isdir];
    files = files(~dirFlags);
    
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
    
    for t = 1:N
        
        [xt,yt,qt,dt] = finddefects(fpath,t);
        x = [x; xt'];
        y = [y; yt'];
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
end