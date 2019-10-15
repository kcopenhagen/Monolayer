function dfieldfigure

%% Make a director image
%fpath = '/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Data/190111KC2/';
%t = 10;
% fpath = '/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Data/190117KC2b/';
% t = 119;
fpath = '/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Data/190111KC2/';
t = 10;
    dir = loaddata(fpath,t,'dfield','float');
%     dir = imrotate(dir,-15,'crop');
%     dir = dir+15/180*pi;
    dir(dir>pi/2) = dir(dir>pi/2)-pi;
    l = laserdata(fpath,t);
    l = l./imgaussfilt(l,64);
    l = normalise(l);
    l = imsharpen(l,'Amount',3,'Radius',3);
    l = normalise(l);
%     l = imrotate(l,-15,'crop');
    holes = loaddata(fpath,t,'manuallayers','int8')<1;
    
    im = real2rgb(dir,colorcet('C2'),[-pi/2 pi/2]);
    figure('Units','pixels','PaperUnits','points','Position',[0 0 1024 768],'PaperPosition',[0 0 1024 768],'PaperSize',[1024 768]);
    ax = axes('Position',[0.025 0.025 0.95 0.95]);
    
    im(:,:,1) = ~holes.*im(:,:,1);
    im(:,:,2) = ~holes.*im(:,:,2);
    im(:,:,3) = ~holes.*im(:,:,3);
    im(:,:,1) = 2*l.*im(:,:,1);
    im(:,:,2) = 2*l.*im(:,:,2);
    im(:,:,3) = 2*l.*im(:,:,3);
    im(im>1) = 1;
    
    imshow(im)
    axis off
    hold on
%     set(gca,'XLim',[260 360],'YLim',[132 207])

%     %
%     x = 335;
%     y = 200;
%     plot([x+2 x+17],[y+4 y+4], 'k', 'Linewidth',8)
%     plot([x+2.5 x+16.5],[y+4 y+4], 'w', 'Linewidth',4)
%     
%     text(x+6,y+1.2,'2\mum','Color','k','FontSize',22)
%     text(x+6,y+0.8,'2\mum','Color','k','FontSize',22)
%     text(x+6.2,y+1,'2\mum','Color','k','FontSize',22)
%     text(x+5.8,y+1,'2\mum','Color','k','FontSize',22)
%     text(x+5.8,y+1.2,'2\mum','Color','k','FontSize',22)
%     text(x+6.2,y+0.8,'2\mum','Color','k','FontSize',22)
%     text(x+6.2,y+1.2,'2\mum','Color','k','FontSize',22)
%     text(x+5.8,y+0.8,'2\mum','Color','k','FontSize',22)
%     text(x+6,y+1,'2\mum','Color','w','FontSize',22)
    
    %%
    
    x = 920;
    y = 750;
    plot([x x+77],[y+4 y+4], 'k', 'Linewidth',8)
    plot([x+2 x+75],[y+4 y+4], 'w', 'Linewidth',4)
    
    text(x+5,y-14,'10\mum','Color','k','FontSize',22)
    text(x+5,y-16,'10\mum','Color','k','FontSize',22)
    text(x+6,y-15,'10\mum','Color','k','FontSize',22)
    text(x+4,y-15,'10\mum','Color','k','FontSize',22)
    text(x+4,y-14,'10\mum','Color','k','FontSize',22)
    text(x+6,y-16,'10\mum','Color','k','FontSize',22)
    text(x+6,y-14,'10\mum','Color','k','FontSize',22)
    text(x+4,y-16,'10\mum','Color','k','FontSize',22)
    text(x+5,y-15,'10\mum','Color','w','FontSize',22)