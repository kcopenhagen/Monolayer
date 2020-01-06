% Pretty figure of heights or layers with defect and laser image overlays.

figure('Units','pixels','PaperUnits','points',...
    'Position',[0 0 672 414],'PaperPosition',[0 0 672 414],'PaperSize',[672 414]);

ax = axes('Units','pixels','Position',[10 20 512 384],'LineWidth',2,...
    'XLim',[0 1024],'YLim',[0 768],'Visible','on',...
    'Xtick',[],'Ytick',[],'Ydir','reverse');

l = laserdata(fpaths{3},10);
l = l./imgaussfilt(l,64);
l = 3*normalise(l)-0.4;
lays = loaddata(fpaths{3},10,'manuallayers','int8');
height = heightdata(fpaths{3},1);
height = height - imgaussfilt(height,128)+0.3;
im = real2rgb(height,myxocmap,[0 0.5]);
imr = im(:,:,1);
img = im(:,:,2);
imb = im(:,:,3);
imr = imr.*l;
img = img.*l;
imb = imb.*l;
im(:,:,1) = imr;
im(:,:,2) = img;
im(:,:,3) = imb;
imshow(im)
axis off

colormap gray
caxis([0.7 1.3])

hold on
defs = load([fpaths{3} 'adefs.mat']);

defs = defs.adefs;
cdefs = defs([defs.ts]==1);
l = 35;
lw = 6;
ms = 45;
ncol = [0 115 178]/255;
pcol = [230 31 15]/255;
ncolrim = ncol;
pcolrim = pcol;
% ncolrim = [0.5 0.9 1];
% pcolrim = [1 0.9 0.5];

for i = 1:numel(cdefs)
    if cdefs(i).q>0
        plot(cdefs(i).x,cdefs(i).y,'.','MarkerSize',ms,'Color',pcolrim)
        plot([cdefs(i).x cdefs(i).x+l*cdefs(i).d(1),...
            cdefs(i).x],...
            [cdefs(i).y cdefs(i).y+l*cdefs(i).d(2),...
            cdefs(i).y],'LineWidth',lw,'Color',pcolrim);
%         plot(cdefs(i).x,cdefs(i).y,'.','MarkerSize',30,'Color',pcol)
%         plot([cdefs(i).x cdefs(i).x+l*cdefs(i).d(1),...
%             cdefs(i).x],...
%             [cdefs(i).y cdefs(i).y+l*cdefs(i).d(2),...
%             cdefs(i).y],'LineWidth',4,'Color',pcol);
    else
        plot(cdefs(i).x,cdefs(i).y,'.','MarkerSize',ms,'Color',ncolrim)
        theta = atan2(cdefs(i).d(2),cdefs(i).d(1));
        plot([cdefs(i).x cdefs(i).x+l*cos(theta) ...
            cdefs(i).x cdefs(i).x+l*cos(theta+2*pi/3) ...
            cdefs(i).x cdefs(i).x+l*cos(theta+4*pi/3),...
            cdefs(i).x],...
            [cdefs(i).y cdefs(i).y+l*sin(theta)...
            cdefs(i).y cdefs(i).y+l*sin(theta+2*pi/3)...
            cdefs(i).y cdefs(i).y+l*sin(theta+4*pi/3),...
            cdefs(i).y],...
            'Color',ncolrim,'LineWidth',lw);
% 
%         plot(cdefs(i).x,cdefs(i).y,'.','MarkerSize',30,'Color',ncol)
%         plot([cdefs(i).x cdefs(i).x+l*cos(theta) ...
%             cdefs(i).x cdefs(i).x+l*cos(theta+2*pi/3) ...
%             cdefs(i).x cdefs(i).x+l*cos(theta+4*pi/3),...
%             cdefs(i).x],...
%             [cdefs(i).y cdefs(i).y+l*sin(theta)...
%             cdefs(i).y cdefs(i).y+l*sin(theta+2*pi/3)...
%             cdefs(i).y cdefs(i).y+l*sin(theta+4*pi/3),...
%             cdefs(i).y],...
%             'Color',ncol,'LineWidth',4);
    end
end

set(ax,'XDir','reverse');
set(ax,'YDir','normal');

x = 40;
y = 20;
plot([x+20 x+172],[y+10 y+10], 'k', 'Linewidth',8)
plot([x+22 x+170],[y+10 y+10], 'w', 'Linewidth',4)
% 
% text(x+5,y-14,'20\mum','Color','k','FontSize',38,'FontName','Helvetica')
% text(x+5,y-16,'20\mum','Color','k','FontSize',38,'FontName','Helvetica')
% text(x+6,y-15,'20\mum','Color','k','FontSize',38,'FontName','Helvetica')
% text(x+4,y-15,'20\mum','Color','k','FontSize',38,'FontName','Helvetica')
% text(x+4,y-14,'20\mum','Color','k','FontSize',38,'FontName','Helvetica')
% text(x+6,y-16,'20\mum','Color','k','FontSize',38,'FontName','Helvetica')
% text(x+6,y-14,'20\mum','Color','k','FontSize',38,'FontName','Helvetica')
% text(x+4,y-16,'20\mum','Color','k','FontSize',38,'FontName','Helvetica')
% text(x+5,y-15,'20\mum','Color','w','FontSize',38,'FontName','Helvetica')