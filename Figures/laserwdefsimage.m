function laserwdefsimage

%% Make a laser image with defects
fpath = '/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Data/190111KC2/';
t = 10;

    l = laserdata(fpath,t);
    
    l = l./imgaussfilt(l,64);
    figure('Units','pixels','PaperUnits','points','Position',[0 0 1024 768],'PaperPosition',[0 0 1024 768],'PaperSize',[1024 768]);
    ax = axes('Position',[0.025 0.025 0.95 0.95]);
    imagesc(l)
    colormap gray
    axis off
    hold on

    adefs = finddefects(fpath,t);
    pdefs = adefs([adefs.q]>0);
    ndefs = adefs([adefs.q]<0);
    
    %Plot +1/2 defs:
    plot([pdefs.x],[pdefs.y],'r.','MarkerSize',30);
    deflen = 15;
    for i = 1:numel(pdefs)
        plot([pdefs(i).x pdefs(i).x+deflen*pdefs(i).d(1)],...
            [pdefs(i).y pdefs(i).y+deflen*pdefs(i).d(2)],'r','LineWidth',3)
    end
    
    plot([ndefs.x],[ndefs.y],'b.','MarkerSize',30);
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
    % Add a scale bar 
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