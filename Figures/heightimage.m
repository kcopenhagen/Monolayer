function heightimage

%% Make a height image
fpath = '/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Data/190111KC2/';
t = 10;

    h = heightdata(fpath,t);
    
    h = h-imgaussfilt(h,128);
    h = h-min(h(:));
    h = rot90(h,2);
    
    figure('Units','pixels','PaperUnits','points',...
        'Position',[0 0 672 414],'PaperPosition',[0 0 672 414],'PaperSize',[672 414]);
    
    ax = axes('Units','pixels','Position',[10 20 512 384],'LineWidth',2,...
        'XLim',[0 1024],'YLim',[0 768],'Visible','on',...
        'Xtick',[],'Ytick',[],'Ydir','reverse');
    
    hold(ax,'on');
    imagesc(ax,h)
    set(ax,'Box','on');
    axis off
    cmap = myxocmap;

    set(gca,'ColorMap',cmap);
    cb = colorbar;
    set(cb,'units','pixels','FontSize',36,'FontName','Latin Modern Math',...
        'Position',[532 20 20 384],'Ytick',0:0.1:0.7,'LineWidth',2,'TickLength',0.05);
    hold on
    x = 870;
    y = 700;
    plot([x+30 x+107],[y+24 y+24], 'k', 'Linewidth',8)
    plot([x+32 x+105],[y+24 y+24], 'w', 'Linewidth',4)
    
    text(x+5,y-14,'10\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
    text(x+5,y-16,'10\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
    text(x+6,y-15,'10\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
    text(x+4,y-15,'10\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
    text(x+4,y-14,'10\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
    text(x+6,y-16,'10\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
    text(x+6,y-14,'10\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
    text(x+4,y-16,'10\mum','Color','k','FontSize',26,'FontName','Latin Modern Math')
    text(x+5,y-15,'10\mum','Color','w','FontSize',26,'FontName','Latin Modern Math')
    