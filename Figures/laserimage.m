function laserimage

%% Make a laser image
fpath = '/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Data/190111KC2/';
t = 10;

    l = laserdata(fpath,t);
    
    l = l./imgaussfilt(l,64);
    l = rot90(l,2);
    
    figure('Units','pixels','PaperUnits','points',...
        'Position',[0 0 672 414],'PaperPosition',[0 0 672 414],'PaperSize',[672 414]);
    
    ax = axes('Units','pixels','Position',[10 20 512 384],'LineWidth',2,...
        'XLim',[0 1024],'YLim',[0 768],'Visible','on',...
        'Xtick',[],'Ytick',[],'Ydir','reverse');
    
    hold(ax,'on');
    imagesc(ax,l)
    set(ax,'Box','on');
    axis off
    cmap = gray;

    set(gca,'ColorMap',cmap);
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
    zix = [265 63];
    ziy = [345 193];
    plot([zix(1) zix(2) zix(2) zix(1) zix(1)],[ziy(1) ziy(1) ziy(2) ziy(2) ziy(1)],...
        'LineWidth',1,'Color','g');

    
    %%
    
    xlim([zix(2) zix(1)])
    ylim([ziy(2) ziy(1)])
    x = zix(1)-25;
    y = ziy(1)-10;
    plot([x+2-15 x+17],[y y], 'k', 'Linewidth',8)
    plot([x+2.5-15 x+16.5],[y y], 'w', 'Linewidth',4)
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