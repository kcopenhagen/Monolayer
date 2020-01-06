%% Example regions

load('heightlaydata','mask','surrs','h');
overlaymaskimr(-h,mask,surrs);
mh = min(-h(:));
Mh = max(-h(:)-1.6*mh);
clim = [1.6*mh Mh+1.6*mh];
clim = clim-min(clim);

%%



%%

load('heightlaydata','dhs');
fig = figure;
ax = axes(fig);

histogram(dhs,'FaceColor','b','edgecolor','none');
set(ax,'LineWidth',2)
xlim([-0.3 0.3])
xticks(-0.3:0.1:0.3)
xticklabels([])
yticks(0:1000:3000)
yticklabels([])
