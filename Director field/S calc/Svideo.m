
%%
rps = [(1:15) (16:2:30) (32:4:200)];
rs = rps*0.133;

minSa = [];
minSg = [];
maxSa = [];
maxSg = [];
meanSa = [];
meanSg = [];
errSa = [];
errSg = [];

for r = rs
    Sa = Sfield(dfield,r/2);
    %Sg = SPhysLC(dfield,r);
    minSa = [minSa; min(Sa(:),[],'omitnan')];
    minSg = [minSg; min(Sg(:),[],'omitnan')];
    maxSa = [maxSa; max(Sa(:),[],'omitnan')];
    maxSg = [maxSg; max(Sg(:),[],'omitnan')];
    meanSa = [meanSa; mean(Sa(:),'omitnan')];
    meanSg = [meanSg; mean(Sg(:),'omitnan')];
    errSa = [errSa; std(Sa(:),'omitnan')];
    errSg = [errSg; std(Sg(:),'omitnan')];
    
end

%%
fig = figure;
axl = axes(fig,'FontSize',12);
%%

plot(rs,maxSa)
hold(axl,'on');

xlabel('a (\mum)');
ylabel('S');


%%
fig = figure('Units','pixels','Position',[100 100 527 399],'Color','w','Visible','off');
axa = axes(fig,'Units','pixels','Position',[5 202 256 192]);
axg = axes(fig,'Units','pixels','Position',[266 202 256 192]);
axl = axes(fig,'Units','pixels','Position',[35 35 487 162]);

set(axg,'Colormap',gray,'Visible','off','xlim',[0 1024],'ylim',[0 768],'clim',[0 1]);
hold(axg,'on')
set(axa,'Colormap',gray,'Visible','off','xlim',[0 1024],'ylim',[0 768],'clim',[0 1]);
hold(axa,'on')


plot(rs,maxSa,'r--','LineWidth',2)
hold(axl,'on');
plot(rs,maxSg,'b--','LineWidth',2)
plot(rs,meanSa,'r','LineWidth',2)
plot(rs,meanSg,'b','LineWidth',2)
xlabel('a (\mum)');
ylabel('S');

F = struct('colormap',[],'cdata',[]);
l = plot([0 0],[0 1],'k','Parent',axl);
t = text(axl, 0, 0.5,[sprintf('a = %2.1f',0) '\mum']); 
for i = 1:numel(rs)
    r = rs(i);
    Sa = Sfield(dfield,r/2);
    Sg = SPhysLC(dfield,r);
    
    imagesc(Sa,'Parent',axa);
    imagesc(Sg,'Parent',axg);
    l.XData = [r r];
    t.String = [sprintf('a = %2.1f',r) '\mum'];
    t.Position = [r+1 0.5];
    F(i) = getframe(fig);

end

close(fig)

%%
v = VideoWriter('video.avi');
v.FrameRate = 5;
v.Quality = 95;
open(v);

for t = 1:numel(F)
    writeVideo(v,F(t));
end
close(v);