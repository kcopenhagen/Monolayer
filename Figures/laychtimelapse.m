addpath('/Users/kcopenhagen/Documents/MATLAB/gitstuff/Monolayer/Defectsandheights/');
laychs = layervsdef(datapath);

%% Identify nearest thing to each layer change event.
for i = 1:numel(laychs)
    dw = laychs(i).dwall;
    dp = sqrt((laychs(i).x-laychs(i).npx)^2+(laychs(i).y-laychs(i).npy)^2);
    dn = sqrt((laychs(i).x-laychs(i).nnx)^2+(laychs(i).y-laychs(i).nny)^2);
    if isempty(dp)
        dp = Inf;
    end
    if isempty(dn)
        dn = Inf;
    end
    if dw < dp && dw < dn
        laychs(i).nearest = 'wall';
    elseif dp < dw && dp < dn
        laychs(i).nearest = 'pos';
    elseif dn < dw && dn < dp
        laychs(i).nearest = 'neg';
    else
        laychs(i).nearest = 'none';
    end
end

XYcal = 0.133;


%% Identify all the layer change events that go with each type of layer change.
   % (New hole, new layer, hole closes, or layer disappears).
   
threetotwo = ([laychs.o] == 3).*([laychs.n] == 2) == 1;
twotoone = ([laychs.o] == 2).*([laychs.n] == 1) == 1;
onetozero = ([laychs.o] == 1).*([laychs.n] == 0) == 1;
zerotoone = ([laychs.o] == 0).*([laychs.n] == 1) == 1;
onetotwo = ([laychs.o] == 1).*([laychs.n] == 2) == 1;
twotothree = ([laychs.o] == 2).*([laychs.n] == 3) == 1;

newhole = [laychs(onetozero) laychs(twotoone) laychs(threetotwo)];
del = [];


for i = 1:numel(newhole)
    if newhole(i).type ~= "create"
        del = [del; i];
    elseif newhole(i).nearest == "wall"
        del = [del; i];
    end
end
newhole(del) = [];

newlayer = [laychs(zerotoone) laychs(onetotwo) laychs(twotothree)];
del = [];

for i = 1:numel(newlayer)
    if newlayer(i).type ~= "create"
        del = [del; i];
    elseif newlayer(i).nearest == "wall"
        del = [del; i];
    end
end

newlayer(del) = [];

loselayer = [laychs(onetozero) laychs(twotoone) laychs(threetotwo)];
del = [];
np = 0;
for i = 1:numel(loselayer)
    if loselayer(i).type ~= "destroy"
        del = [del; i];
    elseif loselayer(i).nearest == "wall"
        del = [del; i];
    end
    
end

loselayer(del) = [];

losehole = [laychs(zerotoone) laychs(onetotwo) laychs(twotothree)];
del = [];
np = 0;
for i = 1:numel(losehole)
    if losehole(i).type ~= "destroy"
        del = [del; i];
    elseif losehole(i).nearest == "wall"
        del = [del; i];
    end
end

losehole(del) = [];

%% Find laychs that happened close to the things we care about
nlp = [];
for i = 1:numel(newlayer)
    
    if newlayer(i).nearest == "pos"
        nlp = [nlp; newlayer(i)];
        
    end
end
nhn = [];
for i = 1:numel(newhole)
    
    if newhole(i).nearest == "neg"
        nhn = [nhn; newhole(i)];
        
    end
end
%% Plot them

    
fig = figure('Units','pixels','Position',[600 400 384 384]);

nl = nlp(8);
ts = getts(nl.fpath);
t = ts(nl.t);
[~,t1] = min(abs((t-120)-ts));
[~,t2] = min(abs((t-60)-ts));
[~,t3] = min(abs((t)-ts));
[~,t4] = min(abs((t+60)-ts));
lts = [t1; t2; t3; t4];



j = 4;
for i = 1:4
    ax = axes(fig,'Units','pixels','Position',[2+(i-1)*96 2+(j-1)*96 92 92]);

    h = heightdata(nl.fpath,lts(i));
    h = h-imgaussfilt(h,64);
    h = h-min(h(:));
    imagesc(h,[0.1 0.6]);
    set(ax,'xlim',[nl.npx-40 nl.npx+40],'ylim',[nl.npy-40 nl.npy+40]);
    set(ax,'Colormap',myxocmap);
    axis off
end

j = 3;
for i = 1:4
    ax = axes(fig,'Units','pixels','Position',[2+(i-1)*96 2+(j-1)*96 92 92]);

    l = laserdata(nl.fpath,lts(i));
    l = l./imgaussfilt(l,64)-0.5;
    imshow(l,'Parent',ax);
    set(ax,'Colormap',gray);
    set(ax,'xlim',[nl.npx-40 nl.npx+40],'ylim',[nl.npy-40 nl.npy+40]);

end


nh = nhn(15);
ts = getts(nh.fpath);
t = ts(nh.t);
[~,t1] = min(abs((t-120)-ts));
[~,t2] = min(abs((t-60)-ts));
[~,t3] = min(abs((t)-ts));
[~,t4] = min(abs((t+60)-ts));
hts = [t1; t2; t3; t4];

j = 2;
for i = 1:4
    ax = axes(fig,'Units','pixels','Position',[2+(i-1)*96 2+(j-1)*96 92 92]);

    h = heightdata(nh.fpath,hts(i));
    h = h-imgaussfilt(h,64);
    h = h-min(h(:));
    imagesc(h,[0.1 0.6]);
    set(ax,'xlim',[nh.nnx-40 nh.nnx+40],'ylim',[nh.nny-40 nh.nny+40]);
    set(ax,'Colormap',myxocmap);
    axis off
end

j = 1;
for i = 1:4
    ax = axes(fig,'Units','pixels','Position',[2+(i-1)*96 2+(j-1)*96 92 92]);

    l = laserdata(nh.fpath,hts(i));
    l = l./imgaussfilt(l,64)-0.5;
    imshow(l,'Parent',ax);
    set(ax,'Colormap',gray);
    set(ax,'xlim',[nh.nnx-40 nh.nnx+40],'ylim',[nh.nny-40 nh.nny+40]);

end

%%

v = VideoWriter('createhole.mp4','MPEG-4');
v.Quality = 95;
v.FrameRate = 30;
open(v);

fig = figure('Units','pixels','Position',[100 100 500 200],'Color','w');
axl = axes(fig,'Units','pixels','Position',[0 0 200 200]);
axh = axes(fig,'Units','pixels','Position',[300 0 200 200]);

def = nh;
xs = round(def.x):round(def.x)+200;
ys = round(def.y):round(def.y)+200;

for t = def.t-34:def.t+34
    l = laserdata(def.fpath,t);
    l = l./imgaussfilt(l,64);
    l = padarray(l,[100 100],NaN,'both');
    l = normalise(l);
    
    im = l(ys,xs);
    im = real2rgb(im,gray);
    
    axes(axl)
    imshow(im)
    
    
    h = heightdata(def.fpath,t);
    h = h-imgaussfilt(h,64);
    h = padarray(h,[100 100],NaN,'both');
    h = h-min(h(:));
    im = h(ys,xs);
    im = real2rgb(im,myxocmap,[0 0.7]);
    
    axes(axh)
    imshow(im)
    
    F = getframe(fig);
    writeVideo(v,F.cdata);
end
close(v)