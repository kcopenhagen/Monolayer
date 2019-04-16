function revperiod = reversal_period
%Estimates reversal period by dividing total time by number of reversals.
files = dir('/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Labeledflows/*mat');
revnum = [];

for f = 1:numel(files)
    load([files(f).folder '/' files(f).name ],'p0s','p1s','p2s','ids');
    temp = strsplit(files(f).name,'t');

    folder = temp{1};
    folder = folder(6:end);

    t = temp{2};
    t = strsplit(t,'.');
    t = str2double(t{1});

    fpath = [fileparts(files(f).folder) '/Data/' folder '/'];
    XYcal = getXYcal(fpath);
    
    fid = fopen([fpath 'times.txt']);
    times = fscanf(fid,'%f');
    
    vx1 = p1s(:,1) - p0s(:,1);
    vy1 = p1s(:,2) - p0s(:,2);
    vx2 = p2s(:,1) - p1s(:,1);
    vy2 = p2s(:,2) - p1s(:,2);
    
    revnum = [revnum; (vx1.*vx2+vy1.*vy2)<0];
    
    times = [times; (times(t+1)-times(t-1))/2 * ones(size(vx1))];
    
end

times = times/60;

revperiod = sum(times)/sum(revnum);
    
end