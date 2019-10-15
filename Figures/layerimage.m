function layerimage

%% Make a layer image
fpath = '/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Data/190111KC2/';
t = 10;

    lays = loaddata(fpath,t,'manuallayers','int8');

    lays = round(imgaussfilt(lays,3));
    lays = rot90(lays,2);
    figure('Units','pixels','PaperUnits','points',...
        'Position',[0 0 672 414],'PaperPosition',[0 0 672 414],'PaperSize',[672 414]);
    
    ax = axes('Units','pixels','Position',[10 20 512 384],'LineWidth',2,...
        'XLim',[0 1024],'YLim',[0 768],'Visible','on',...
        'Xtick',[],'Ytick',[],'Ydir','reverse');
    imagesc(lays)
    axis off
    cmap = myxocmap;
    set(gca,'ColorMap',cmap);
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