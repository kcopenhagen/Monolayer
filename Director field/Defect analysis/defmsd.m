function [dt, dr, qq] = defmsd(datapath)
%Adding path to function that finds defects.
addpath('../');

%Preparing the list of experiments to go through.
folders = dir(datapath);
dirFlags = [folders.isdir];
folders = folders(dirFlags);
del = [];
for i = 1:numel(folders)
    if folders(i).name(1) == '.'
        del = [del; i];
    end
end
folders(del) = [];

%These are the outputs of the calculations that I want.
dr = [];
dt = [];
qq = [];

for f = 1:numel(folders) %Loop through experiments.
    f
    %Load in and prep values.
    fpath = [folders(f).folder '/' folders(f).name '/'];
    XYcal = getXYcal(fpath);
    adefs = alldefects(fpath);
    
    %Find the defects that existed for at least 10 frames.
    [a,b] = histcounts([adefs.id],'BinMethod','integer');
    b = b(2:end)-0.5;

    ids = b(a>10);
    ids = ismember([adefs.id],ids);
    
    adefs(~ids) = [];
    
    deflabs = unique([adefs.id]);

    for i = 1:numel(deflabs)
        
        xi = XYcal*[adefs([adefs.id] == deflabs(i)).x];
        yi = XYcal*[adefs([adefs.id] == deflabs(i)).y];
        tti = [adefs([adefs.id] == deflabs(i)).tt];
        qi = [adefs([adefs.id] == deflabs(i)).q];

        for t = 1:numel(tti)
            for t2 = 1:numel(tti)-t
                dx = xi(t+t2)-xi(t2);
                dy = yi(t+t2)-yi(t2);
                dr = [dr; (dx^2+dy^2)];
                dt = [dt; tti(t+t2)-tti(t2)];
                qq = [qq; qi(1)];
            end
        end
    end
end