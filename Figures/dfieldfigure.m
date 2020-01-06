function dfieldfigure

%% Make a director image
%fpath = '/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Data/190111KC2/';
%t = 10;
% fpath = '/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Data/190117KC2b/';
% t = 119;
load('orientcmap','mymap');

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
    
    im = real2rgb(dir,mymap,[-pi/2 pi/2]);
    figure('Units','pixels','PaperUnits','points',...
        'Position',[0 0 672 414],'PaperPosition',[0 0 672 414],'PaperSize',[672 414]);
    
    ax = axes('Units','pixels','Position',[10 20 512 384],'LineWidth',2,...
        'XLim',[0 1024],'YLim',[0 768],'Visible','on',...
        'Xtick',[],'Ytick',[],'Ydir','reverse');
    
    hold(ax,'on');
    S = loaddata(fpath,t,'order','float');
    im = real2rgb(S,colorcet('L6'),[0 1]);
    im(:,:,1) = ~holes.*im(:,:,1);
    im(:,:,2) = ~holes.*im(:,:,2);
    im(:,:,3) = ~holes.*im(:,:,3);
    im(:,:,1) = 2*l.*im(:,:,1);
    im(:,:,2) = 2*l.*im(:,:,2);
    im(:,:,3) = 2*l.*im(:,:,3);
    im(im>1) = 1;
    im = rot90(im,2);
    imshow(im)
    axis off
    hold on
    
    x = 870;
    y = 700;
    plot([x+30-75 x+107],[y+24 y+24], 'k', 'Linewidth',8)
    plot([x+32-75 x+105],[y+24 y+24], 'w', 'Linewidth',4)
    
%     text(x+5,y-14,'10\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
%     text(x+5,y-16,'10\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
%     text(x+6,y-15,'10\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
%     text(x+4,y-15,'10\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
%     text(x+4,y-14,'10\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
%     text(x+6,y-16,'10\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
%     text(x+6,y-14,'10\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
%     text(x+4,y-16,'10\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
%     text(x+5,y-15,'10\mum','Color','w','FontSize',26,'FontName','Latin Modern Math')
%     
    zix = [568 672];
    ziy = [376 454];
    plot([zix(1) zix(2) zix(2) zix(1) zix(1)],[ziy(1) ziy(1) ziy(2) ziy(2) ziy(1)],...
        'LineWidth',1,'Color','k');
    
    
    %% Zoomed in
    
    xlim(zix);
    ylim(ziy);
    
    x = zix(2)-20;
    y = ziy(2)-6;
    plot([x-2 x+13],[y y], 'k', 'Linewidth',8)
    plot([x-1.5 x+12.5],[y y], 'w', 'Linewidth',4)
%     
%     text(x,y-3.8,'2\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
%     text(x,y-4.2,'2\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
%     text(x+0.2,y-4,'2\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
%     text(x-0.2,y-4,'2\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
%     text(x-0.2,y-3.8,'2\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
%     text(x+0.2,y-4.2,'2\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
%     text(x+0.2,y-3.8,'2\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
%     text(x-0.2,y-4.2,'2\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
%    text(x,y-4,'2\mum','Color','w','FontSize',26,'FontName','Latin Modern Math')
    