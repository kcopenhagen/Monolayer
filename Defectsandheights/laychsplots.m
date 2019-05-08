function laychsplots(datapath)
addpath('/Users/kcopenhagen/Documents/MATLAB/gitstuff/Monolayer/Height analysis/Layer formation/IDing Layers');
laychs = layervsdef(datapath);

%% Identify nearest thing to each layer change event.
for i = 1:numel(laychs)
    dw = laychs(i).dwall;
    dp = sqrt((laychs(i).x-laychs(i).npx)^2+(laychs(i).y-laychs(i).npy)^2);
    dn = sqrt((laychs(i).x-laychs(i).nnx)^2+(laychs(i).y-laychs(i).nny)^2);
    
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

%% Make some images for each thing

csc = 20;
ocsc = 3;
impf = zeros(401,401,3);
imnf = zeros(401,401,3);

% Things to do with creating new layers.
for i = 1:numel(newlayer)
    imsize = 401;
    if true%newlayer(i).nearest == "pos"
        mask = zeros(768,1024);
        mask(newlayer(i).idx) = 1;
        mask = padarray(mask,[(imsize-1)/2 (imsize-1)/2],0,'both');
        mask = mask(round(newlayer(i).npy+imsize/2-(imsize-1)/2):...
            round(newlayer(i).npy+imsize/2+(imsize-1)/2),...
            round(newlayer(i).npx+imsize/2-(imsize-1)/2):...
            round(newlayer(i).npx+imsize/2+(imsize-1)/2));

        mask = imrotate(mask,atan2d(newlayer(i).npd(2),newlayer(i).npd(1)),'nearest','crop');
        impf(:,:,1) = impf(:,:,1) + mask * csc/numel(newlayer);
        impf(:,:,2) = impf(:,:,2) + mask * csc/(ocsc*numel(newlayer));
        impf(:,:,3) = impf(:,:,3) + mask * csc/(ocsc*numel(newlayer));
    end
    
    if true%newlayer(i).nearest == "neg"
        mask = zeros(768,1024);
        mask(newlayer(i).idx) = 1;
        mask = padarray(mask,[(imsize-1)/2 (imsize-1)/2],0,'both');
        mask = mask(round(newlayer(i).nny+imsize/2-(imsize-1)/2):...
            round(newlayer(i).nny+imsize/2+(imsize-1)/2),...
            round(newlayer(i).nnx+imsize/2-(imsize-1)/2):...
            round(newlayer(i).nnx+imsize/2+(imsize-1)/2));
        
        dx = newlayer(i).x-newlayer(i).nnx;
        dy = newlayer(i).y-newlayer(i).nny;
        phi = atan2d(dy,dx);
        theta = atan2d(newlayer(i).nnd(2),newlayer(i).nnd(1));
        
        dtheta = theta-phi;
        
        while abs(dtheta)>60
            if theta>phi
                theta = theta - 120;
            else
                theta = theta + 120;
            end
            dtheta = theta - phi;
        end
        
        mask = imrotate(mask,theta,'nearest','crop');
        imnf(:,:,1) = imnf(:,:,1) + mask * csc/numel(newlayer);
        imnf(:,:,2) = imnf(:,:,2) + mask * csc/(ocsc*numel(newlayer));
        imnf(:,:,3) = imnf(:,:,3) + mask * csc/(ocsc*numel(newlayer));
    end
end

for i = 1:numel(newhole)
    imsize = 401;
    if true%newhole(i).nearest == "pos"
        mask = zeros(768,1024);
        mask(newhole(i).idx) = 1;
        mask = padarray(mask,[(imsize-1)/2 (imsize-1)/2],0,'both');
        mask = mask(round(newhole(i).npy+imsize/2-(imsize-1)/2):...
            round(newhole(i).npy+imsize/2+(imsize-1)/2),...
            round(newhole(i).npx+imsize/2-(imsize-1)/2):...
            round(newhole(i).npx+imsize/2+(imsize-1)/2));

        mask = imrotate(mask,atan2d(newhole(i).npd(2),newhole(i).npd(1)),'nearest','crop');
        impf(:,:,3) = impf(:,:,3) + mask * csc/numel(newhole);
        impf(:,:,2) = impf(:,:,2) + mask * csc/(ocsc*numel(newhole));
        impf(:,:,1) = impf(:,:,1) + mask * csc/(ocsc*numel(newhole));
    end
    
    if true%newhole(i).nearest == "neg"
        mask = zeros(768,1024);
        mask(newhole(i).idx) = 1;
        mask = padarray(mask,[(imsize-1)/2 (imsize-1)/2],0,'both');
        mask = mask(round(newhole(i).nny+imsize/2-(imsize-1)/2):...
            round(newhole(i).nny+imsize/2+(imsize-1)/2),...
            round(newhole(i).nnx+imsize/2-(imsize-1)/2):...
            round(newhole(i).nnx+imsize/2+(imsize-1)/2));

        
        dx = newhole(i).x-newhole(i).nnx;
        dy = newhole(i).y-newhole(i).nny;
        phi = atan2d(dy,dx);
        theta = atan2d(newhole(i).nnd(2),newhole(i).nnd(1));
        
        dtheta = theta-phi;
        
        while abs(dtheta)>60
            if theta>phi
                theta = theta - 120;
            else
                theta = theta + 120;
            end
            dtheta = theta - phi;
        end
        
        mask = imrotate(mask,theta,'nearest','crop');
        imnf(:,:,3) = imnf(:,:,3) + mask * csc/numel(newhole);
        imnf(:,:,2) = imnf(:,:,2) + mask * csc/(ocsc*numel(newhole));
        imnf(:,:,1) = imnf(:,:,1) + mask * csc/(ocsc*numel(newhole));
    end
end

impc = zeros(401,401,3);
imnc = zeros(401,401,3);

% Things to do with creating new layers.
for i = 1:numel(loselayer)
    imsize = 401;
    if true%loselayer(i).nearest == "pos"
        mask = zeros(768,1024);
        mask(loselayer(i).idx) = 1;
        mask = padarray(mask,[(imsize-1)/2 (imsize-1)/2],0,'both');
        mask = mask(round(loselayer(i).npy+imsize/2-(imsize-1)/2):...
            round(loselayer(i).npy+imsize/2+(imsize-1)/2),...
            round(loselayer(i).npx+imsize/2-(imsize-1)/2):...
            round(loselayer(i).npx+imsize/2+(imsize-1)/2));

        mask = imrotate(mask,atan2d(loselayer(i).npd(2),loselayer(i).npd(1)),'nearest','crop');
        impc(:,:,1) = impc(:,:,1) + mask * csc/numel(loselayer);
        impc(:,:,2) = impc(:,:,2) + mask * csc/(ocsc*numel(loselayer));
        impc(:,:,3) = impc(:,:,3) + mask * csc/(ocsc*numel(loselayer));
    end
    
    if true%loselayer(i).nearest == "neg"
        mask = zeros(768,1024);
        mask(loselayer(i).idx) = 1;
        mask = padarray(mask,[(imsize-1)/2 (imsize-1)/2],0,'both');
        mask = mask(round(loselayer(i).nny+imsize/2-(imsize-1)/2):...
            round(loselayer(i).nny+imsize/2+(imsize-1)/2),...
            round(loselayer(i).nnx+imsize/2-(imsize-1)/2):...
            round(loselayer(i).nnx+imsize/2+(imsize-1)/2));

        dx = loselayer(i).x-loselayer(i).nnx;
        dy = loselayer(i).y-loselayer(i).nny;
        phi = atan2d(dy,dx);
        theta = atan2d(loselayer(i).nnd(2),loselayer(i).nnd(1));
        
        dtheta = theta-phi;
        
        while abs(dtheta)>60
            if theta>phi
                theta = theta - 120;
            else
                theta = theta + 120;
            end
            dtheta = theta - phi;
        end
        
        mask = imrotate(mask,theta,'nearest','crop');
        imnc(:,:,1) = imnc(:,:,1) + mask * csc/numel(loselayer);
        imnc(:,:,2) = imnc(:,:,2) + mask * csc/(ocsc*numel(loselayer));
        imnc(:,:,3) = imnc(:,:,3) + mask * csc/(ocsc*numel(loselayer));
        
    end
end

for i = 1:numel(losehole)
    imsize = 401;
    if true%losehole(i).nearest == "pos"
        mask = zeros(768,1024);
        mask(losehole(i).idx) = 1;
        mask = padarray(mask,[(imsize-1)/2 (imsize-1)/2],0,'both');
        mask = mask(round(losehole(i).npy+imsize/2-(imsize-1)/2):...
            round(losehole(i).npy+imsize/2+(imsize-1)/2),...
            round(losehole(i).npx+imsize/2-(imsize-1)/2):...
            round(losehole(i).npx+imsize/2+(imsize-1)/2));

        mask = imrotate(mask,atan2d(losehole(i).npd(2),losehole(i).npd(1)),'nearest','crop');
        impc(:,:,3) = impc(:,:,3) + mask * csc/numel(losehole);
        impc(:,:,1) = impc(:,:,1) + mask * csc/(ocsc*numel(losehole));
        impc(:,:,2) = impc(:,:,2) + mask * csc/(ocsc*numel(losehole));
    end
    
    if true%losehole(i).nearest == "neg"
        mask = zeros(768,1024);
        mask(losehole(i).idx) = 1;
        mask = padarray(mask,[(imsize-1)/2 (imsize-1)/2],0,'both');
        mask = mask(round(losehole(i).nny+imsize/2-(imsize-1)/2):...
            round(losehole(i).nny+imsize/2+(imsize-1)/2),...
            round(losehole(i).nnx+imsize/2-(imsize-1)/2):...
            round(losehole(i).nnx+imsize/2+(imsize-1)/2));

        dx = losehole(i).x-losehole(i).nnx;
        dy = losehole(i).y-losehole(i).nny;
        phi = atan2d(dy,dx);
        theta = atan2d(losehole(i).nnd(2),losehole(i).nnd(1));
        
        dtheta = theta-phi;
        
        while abs(dtheta)>60
            if theta>phi
                theta = theta - 120;
            else
                theta = theta + 120;
            end
            dtheta = theta - phi;
        end
        
        mask = imrotate(mask,theta,'nearest','crop');
        imnc(:,:,3) = imnc(:,:,3) + mask * csc/numel(losehole);
        imnc(:,:,1) = imnc(:,:,1) + mask * csc/(ocsc*numel(losehole));
        imnc(:,:,2) = imnc(:,:,2) + mask * csc/(ocsc*numel(losehole));
    end
end

f = figure('Units','pixels','Position',[0 0 401 401],'PaperUnits','points',...
    'PaperSize',[401 401],'PaperPosition',[0 0 401 401]);
ax = axes(f,'Units','pixels','Position',[0 0 401 401]);
imshow(impf,'Parent',ax)
hold on
plot(200,200,'k.','MarkerSize',20)
plot([200 211],[200 200],'k','LineWidth',3)
plot(200,200,'w.','MarkerSize',15)
plot([200 210],[200 200],'w','LineWidth',1)

plot([352 380],[380 380],'w','LineWidth',2)
text(355,370,'5\mum','Color','w');

f = figure('Units','pixels','Position',[0 0 401 401],'PaperUnits','points',...
    'PaperSize',[401 401],'PaperPosition',[0 0 401 401]);
ax = axes(f,'Units','pixels','Position',[0 0 401 401]);
imshow(imnf,'Parent',ax)
hold on
plot(200,200,'k.','MarkerSize',20)
plot([200 211],[200 200],'k','LineWidth',3)
plot([200 200+11*cos(2*pi/3)],[200 200+11*sin(2*pi/3)],'k','LineWidth',3);
plot([200 200+11*cos(4*pi/3)],[200 200+11*sin(4*pi/3)],'k','LineWidth',3);
plot(200,200,'w.','MarkerSize',15)
plot([200 210],[200 200],'w','LineWidth',1)
plot([200 200+10*cos(2*pi/3)],[200 200+10*sin(2*pi/3)],'w','LineWidth',1);
plot([200 200+10*cos(4*pi/3)],[200 200+10*sin(4*pi/3)],'w','LineWidth',1);

plot([352 380],[380 380],'w','LineWidth',2)
text(355,370,'5\mum','Color','w');

f = figure('Units','pixels','Position',[0 0 401 401],'PaperUnits','points',...
    'PaperSize',[401 401],'PaperPosition',[0 0 401 401]);
ax = axes(f,'Units','pixels','Position',[0 0 401 401]);
imshow(impc,'Parent',ax)
hold on
plot(200,200,'k.','MarkerSize',20)
plot([200 211],[200 200],'k','LineWidth',3)
plot(200,200,'w.','MarkerSize',15)
plot([200 210],[200 200],'w','LineWidth',1)
plot([352 380],[380 380],'k','LineWidth',2)
text(355,370,'5\mum','Color','w');

f = figure('Units','pixels','Position',[0 0 401 401],'PaperUnits','points',...
    'PaperSize',[401 401],'PaperPosition',[0 0 401 401]);
ax = axes(f,'Units','pixels','Position',[0 0 401 401]);
imshow(imnc,'Parent',ax)
hold on
plot(200,200,'k.','MarkerSize',20)
plot([200 211],[200 200],'k','LineWidth',3)
plot([200 200+11*cos(2*pi/3)],[200 200+11*sin(2*pi/3)],'k','LineWidth',3);
plot([200 200+11*cos(4*pi/3)],[200 200+11*sin(4*pi/3)],'k','LineWidth',3);
plot(200,200,'w.','MarkerSize',15)
plot([200 210],[200 200],'w','LineWidth',1)
plot([200 200+10*cos(2*pi/3)],[200 200+10*sin(2*pi/3)],'w','LineWidth',1);
plot([200 200+10*cos(4*pi/3)],[200 200+10*sin(4*pi/3)],'w','LineWidth',1);

plot([352 380],[380 380],'w','LineWidth',2)
text(355,370,'5\mum','Color','w');

%%
x = 1:5;
y = 0:300;
[xx,yy] = meshgrid(x,y);

ncbar = zeros(numel(y),numel(x),3);
ncbar(:,:,3) = csc*(yy/max(y));
ncbar(:,:,2) = csc/ocsc*(yy/max(y));
ncbar(:,:,1) = csc/ocsc*(yy/max(y));

show(ncbar)
set(gca,'YDir','normal')
set(gca,'YLim', [0 max(y)/ceil(csc/ocsc)+2]);
x = 1:5;
y = 0:300;
[xx,yy] = meshgrid(x,y);

pcbar = zeros(numel(y),numel(x),3);
pcbar(:,:,1) = csc*(yy/max(y));
pcbar(:,:,2) = csc/ocsc*(yy/max(y));
pcbar(:,:,3) = csc/ocsc*(yy/max(y));

show(pcbar)
set(gca,'YDir','normal')
set(gca,'YLim', [0 max(y)/ceil(csc/ocsc)+2]);