function laserwdefstimeseries

%% Make a laser image with defects
% fpath = '/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Data/190111KC2/';
% t = 10;

figure('Units','pixels','Position',[100 100 1024/5+1024+10 round(768/2.5)+10],'PaperUnits','points',...
    'PaperPosition',[0 0 1024/5+1024+10 round(768/2.5)+10],'PaperSize',[1024/5+1024+10 round(768/2.5)+10]);
fpath = '/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Data/190111KC2/';
toff = 107;
ts = 1;
for t = 0:11
    ax = axes('Units','pixels','Position',[mod((t),6)*(1024/5)+10 ...
    floor((11-t)/6)*(768/5+10) round(1024/5)-10 round(768/5)]);
    tt = ts*t+toff;
    l = laserdata(fpath,tt);
    
    l = l./imgaussfilt(l,64);

    imagesc(l)
    colormap gray
    axis off
    hold on

    adefs = finddefects(fpath,tt);
    pdefs = adefs([adefs.q]>0);
    ndefs = adefs([adefs.q]<0);
    
    %Plot +1/2 defs:
    plot([pdefs.x],[pdefs.y],'r.','MarkerSize',15);
    deflen = 8;
    for i = 1:numel(pdefs)
        plot([pdefs(i).x pdefs(i).x+deflen*pdefs(i).d(1)],...
            [pdefs(i).y pdefs(i).y+deflen*pdefs(i).d(2)],'r','LineWidth',3)
    end
    
    plot([ndefs.x],[ndefs.y],'b.','MarkerSize',15);
    for i = 1:numel(ndefs)
        angle = atan2(ndefs(i).d(2),ndefs(i).d(1));
        
        plot([ndefs(i).x ndefs(i).x+deflen*cos(angle)],...
            [ndefs(i).y ndefs(i).y+deflen*sin(angle)],'b','LineWidth',3)
        angle = angle+2*pi/3;
        plot([ndefs(i).x ndefs(i).x+deflen*cos(angle)],...
            [ndefs(i).y ndefs(i).y+deflen*sin(angle)],'b','LineWidth',3)
        angle = angle+2*pi/3;
        plot([ndefs(i).x ndefs(i).x+deflen*cos(angle)],...
            [ndefs(i).y ndefs(i).y+deflen*sin(angle)],'b','LineWidth',3)
    end
    
    set(gca,'XLim',[320 522],'YLim',[205 357])

end
    %% Add a scale bar
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