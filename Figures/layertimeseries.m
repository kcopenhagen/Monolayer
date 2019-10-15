function layertimeseries
figure('Units','pixels','Position',[100 100 1024+10 round(768/2.5)+10],'PaperUnits','points',...
    'PaperPosition',[0 0 1024+10 round(768/2.5)+10],'PaperSize',[1024+10 round(768/2.5)+10]);
fpath = '/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Data/190111KC2/';
toff = 10;
ts = 5;
for t = 0:9    
    tt = ts*t+toff;
    lays = loaddata(fpath,tt,'manuallayers','int8');

    lays = round(imgaussfilt(lays,3));

    ax = axes('Units','pixels','Position',[mod((t),5)*(1024/5)+10 ...
        floor((9-t)/5)*(768/5+10) round(1024/5)-10 round(768/5)]);
    imagesc(lays)
    colormap(myxocmap)
    axis off
    
end