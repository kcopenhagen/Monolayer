function defectinteractions_angles(datapath)

%%

    addpath('../');
    fpaths = getfold(datapath);
    
    ppr = [];
    nnr = [];
    pnr = [];
    npr = [];
    
    ppa = [];
    nna = [];
    pna = [];
    npa = [];

    ppp = [];
    nnp = [];
    pnp = [];
    npp = [];
    
    for f = 1:numel(fpaths)
        fpath = fpaths{f};
        load([fpath 'adefs.mat'],'adefs');
        tts = unique([adefs.ts]);
        for tt = 1:numel(tts)
            t = tts(tt);
            cdefs = adefs([adefs.ts]==t);
            
            cds = [cdefs.d];
            dx1 = cds(1:2:end-1);
            dy1 = cds(2:2:end);
            x = [cdefs.x];
            y = [cdefs.y];
            q = [cdefs.q];
            
            x = [x x(q<0) x(q<0)];
            y = [y y(q<0) y(q<0)];
            dxt = [dx1 dx1(q<0)*cos(2*pi/3)-dy1(q<0)*sin(2*pi/3)...
                dx1(q<0)*cos(4*pi/3)-dy1(q<0)*sin(4*pi/3)];
            dy1 = [dy1 dx1(q<0)*sin(2*pi/3)+dy1(q<0)*cos(2*pi/3)...
                dx1(q<0)*sin(4*pi/3)+dy1(q<0)*cos(4*pi/3)];
            dx1 = dxt;
            q = [q q(q<0) q(q<0)];
            
            dx = ones(numel(dx1),1)*dx1;
            dy = ones(numel(dy1),1)*dy1;
            
            rx = (x' - x);
            ry = (y' - y);
            rs = sqrt(rx.^2+ry.^2);
            
            dq = q + q';
            qs = ones(numel(q),1)*q;
            dq(dq==0) = qs(dq==0);
            
            angle = sign(dx.*ry-dy.*rx).*acos((rx.*dx+ry.*dy)./rs);
            phi = sign(rx.*dy'-ry.*dx').*acos((dx'.*rx+dy'.*ry)./rs);
            
            ppr = [ppr; rs(dq==1)];
            pnr = [pnr; rs(dq==0.5)];
            npr = [npr; rs(dq==-0.5)];
            nnr = [nnr; rs(dq==-1)];
            
            ppa = [ppa; angle(dq==1)];
            pna = [pna; angle(dq==0.5)];
            npa = [npa; angle(dq==-0.5)];
            nna = [nna; angle(dq==-1)];
            
            ppp = [ppp; phi(dq==1)];
            pnp = [pnp; phi(dq==0.5)];
            npp = [npp; phi(dq==-0.5)];
            nnp = [nnp; phi(dq==-1)];
        end
    end
    
%     ppa = ppa((ppr>13).*(ppr<300)==1);
%     pna = pna((pnr>3).*(pnr<300)==1);
%     npa = npa((npr>3).*(npr<300)==1);
%     nna = nna((nnr>13).*(nnr<300)==1);
%     
%     ppp = ppp((ppr>13).*(ppr<300)==1);
%     pnp = pnp((pnr>3).*(pnr<300)==1);
%     npp = npp((npr>3).*(npr<300)==1);
%     nnp = nnp((nnr>13).*(nnr<300)==1);
%     
%     ppr = ppr((ppr>13).*(ppr<300)==1);
%     pnr = pnr((pnr>3).*(pnr<300)==1);
%     npr = npr((npr>3).*(npr<300)==1);
%     nnr = nnr((nnr>13).*(nnr<300)==1);
% 
%     ppa = ppa(ppr>13);
%     pna = pna(pnr>3);
%     npa = npa(npr>3);
%     nna = nna(nnr>13);
%     
%     ppp = ppp(ppr>13);
%     pnp = pnp(pnr>3);
%     npp = npp(npr>3);
%     nnp = nnp(nnr>13);
%     
%     ppr = ppr(ppr>13);
%     pnr = pnr(pnr>3);
%     npr = npr(npr>3);
%     nnr = nnr(nnr>13);
    
    
    %% Plot r / theta with phi as a color.
    circt = 0:0.01:2*pi;
    clims = [-pi pi];
    thetas = -pi:pi/20:pi;

    %cmap = colorcet('C1');
    cmap = defdircmap;
    ms = 3;
    figure('Units','pixels','Position',...
        [200 200 300+300+130+100 300+300+40*3],...
        'PaperUnits','points','PaperPosition',...
        [0 0 300+300+130+100 300+300+40*3],'PaperSize',...
        [300+300+130+100 300+300+40*3])
    
    axes('Units','pixels','Position',[50 80+300 300 300],'box','on');
    colors = squeeze(real2rgb(ppp(ppr<200),cmap,clims));
    scatter(ppr(ppr<200).*cos(ppa(ppr<200)),ppr(ppr<200).*sin(ppa(ppr<200)),ms,colors,'filled');
    hold on
    plot(0,0,'k.','MarkerSize',10);
    plot([0 10],[0 0],'k','LineWidth',1.5);
    plot(200*cos(circt),200*sin(circt),'k','LineWidth',1)
    plot(75*cos(circt),75*sin(circt),'k--','LineWidth',1)
    xlim([-200 200])
    ylim([-200 200])
    axis off
    xticks([])
    xticklabels(-50:10:50)
    yticks(-376:75:376)
    yticklabels(-50:10:50)
    ylabel('\mum')
    
    pnta = pna(((pnp<pi/3).*(pnp>-pi/3))==1);
    pntr = pnr(((pnp<pi/3).*(pnp>-pi/3))==1);
    pntp = pnp(((pnp<pi/3).*(pnp>-pi/3))==1);
    axes('Units','pixels','Position',[50 40 300 300]);
    colors = squeeze(real2rgb(pntp(pntr<200),cmap,clims/3));
    scatter(pntr(pntr<200).*cos(pnta(pntr<200)),pntr(pntr<200).*sin(pnta(pntr<200)),ms,colors,'filled');
    hold on
    axis off
    plot(0,0,'k.','MarkerSize',10);
    plot([0 10],[0 0],'k','LineWidth',1.5);
    plot(200*cos(circt),200*sin(circt),'k','LineWidth',1)
    plot(75*cos(circt),75*sin(circt),'k--','LineWidth',1)
    xlim([-200 200])
    ylim([-200 200])
    xticks(-376:75:376)
    xticklabels(-50:10:50)
    yticks(-376:75:376)
    yticklabels(-50:10:50)
    xlabel('\mum')
    ylabel('\mum')

    
    axes('Units','pixels','Position',[90+300 80+300 300 300]);
    colors = squeeze(real2rgb(npp(npr<200),cmap,clims));
    scatter(npr(npr<200).*cos(npa(npr<200)),npr(npr<200).*sin(npa(npr<200)),ms,colors,'filled');
    hold on
    axis off
    plot(0,0,'k.','MarkerSize',10);
    quiver([0 0 0],[0 0 0],[10 10*cos(2*pi/3) 10*cos(4*pi/3)],...
        [0 10*sin(2*pi/3) 10*sin(4*pi/3)],'k','AutoScale','off',...
        'ShowArrowHead','off','LineWidth',1.5)
    plot(200*cos(circt),200*sin(circt),'k','LineWidth',1)
    plot(75*cos(circt),75*sin(circt),'k--','LineWidth',1)
    xlim([-200 200])
    ylim([-200 200])
    xticks([])
    xticklabels(-50:10:50)
    yticks([])
    yticklabels(-50:10:50)
    
    nnta = nna(((nnp<pi/3).*(nnp>-pi/3))==1);
    nntr = nnr(((nnp<pi/3).*(nnp>-pi/3))==1);
    nntp = nnp(((nnp<pi/3).*(nnp>-pi/3))==1);
    axes('Units','pixels','Position',[90+300 40 300 300]);
    colors = squeeze(real2rgb(nntp(nntr<200),cmap,clims/3));
    scatter(nntr(nntr<200).*cos(nnta(nntr<200)),nntr(nntr<200).*sin(nnta(nntr<200)),ms,colors,'filled');
    hold on
    axis off
    plot(0,0,'k.','MarkerSize',10);
    quiver([0 0 0],[0 0 0],[10 10*cos(2*pi/3) 10*cos(4*pi/3)],...
        [0 10*sin(2*pi/3) 10*sin(4*pi/3)],'k','AutoScale','off',...
        'ShowArrowHead','off','LineWidth',1.5)
    plot(200*cos(circt),200*sin(circt),'k','LineWidth',1)
    plot(75*cos(circt),75*sin(circt),'k--','LineWidth',1)
    xlim([-200 200])
    ylim([-200 200])
    xticks(-376:75:376)
    xticklabels(-50:10:50)
    yticks([])
    yticklabels(-50:10:50)
    xlabel('\mum')
    
%     cmimx = 1:20;
%     cmimy = 1:round(400+400/3+40*3-80);
%     [~,cmim] = meshgrid(cmimx,cmimy);
%     axes('Units','pixels','Position',[130+300+300 80+300 20 300])
%     cmim = real2rgb(cmim,cmap);
%     imshow(cmim);
%     set(gca,'YDir','normal','YAxisLocation','right');
%     axis on
%     box on
%     yticks([1 max(cmimy)/2 max(cmimy)]);
%     yticklabels(["-\pi" "0" "\pi"]);
%     xticks([-10 50])
%     ylabel('\phi')
% 
%     axes('Units','pixels','Position',[130+300+300 40 20 300])
%     imshow(cmim);
%     set(gca,'YDir','normal','YAxisLocation','right');
%     axis on
%     box on
%     yticks([1 max(cmimy)/2 max(cmimy)]);
%     yticklabels(["-\pi/3" "0" "\pi/3"]);
%     xticks([-10 50])
%     ylabel('\phi')
%     
    eds = -pi:pi/12:pi;
    filt = [1/2 1/2];
    ec = conv(eds,filt,'valid');
    
    ppat = ppa(ppr<75);
    pnat = pna(pnr<75);
    npat = npa(npr<75);
    nnat = nna(nnr<75);
    
    ppac = histcounts(ppat,eds);
    pnac = histcounts(pnat,eds);
    npac = histcounts(npat,eds);
    nnac = histcounts(nnat,eds);
    
    ppac = [ppac ppac(1)];
    pnac = [pnac pnac(1)];
    npac = [npac npac(1)];
    nnac = [nnac nnac(1)];
    ec = [ec ec(1)];
    
    axes('Units','pixels','Position',[50+220 80+300+220 80 80])
    fill(1000*cos(circt),1000*sin(circt),'w')
    hold on
    plot(0,0,'k.','MarkerSize',10)
    plot(3*ppac.*cos(ec),3*ppac.*sin(ec),'r','LineWidth',1.5)
    plot(1000*cos(circt),1000*sin(circt),'k','LineWidth',1)
    axis off
    xlim([-1000 1000])
    ylim([-1000 1000])
 
    axes('Units','pixels','Position',[50+220 40+220 80 80])
    fill(1000*cos(circt),1000*sin(circt),'w')
    hold on
    plot(0,0,'k.','MarkerSize',10)
    plot(pnac.*cos(ec),pnac.*sin(ec),'b','LineWidth',1.5)
    plot(1000*cos(circt),1000*sin(circt),'k','LineWidth',1)
    axis off
    xlim([-1000 1000])
    ylim([-1000 1000])
    
    axes('Units','pixels','Position',[90+300+220 80+300+220 80 80])
    fill(1000*cos(circt),1000*sin(circt),'w')
    hold on
    plot(0,0,'k.','MarkerSize',10)
    plot(npac.*cos(ec),npac.*sin(ec),'r','LineWidth',1.5)
    plot(1000*cos(circt),1000*sin(circt),'k','LineWidth',1)
    axis off
    xlim([-1000 1000])
    ylim([-1000 1000])
    
    axes('Units','pixels','Position',[90+300+220 40+220 80 80])
    fill(1000*cos(circt),1000*sin(circt),'w')
    hold on
    plot(0,0,'k.','MarkerSize',10)
    plot(nnac.*cos(ec)/3,nnac.*sin(ec)/3,'b','LineWidth',1.5)
    plot(1000*cos(circt),1000*sin(circt),'k','LineWidth',1)
    axis off
    xlim([-1000 1000])
    ylim([-1000 1000])    
    
    axes('Units','pixels','Position',[25+300 80+300 90 90])
    x = -100:100;
    y = -100:100;
    [xx,yy] = meshgrid(x,y);
    angles = atan2(yy,xx);
    im = real2rgb(angles,cmap,[-pi pi]);

    rr = sqrt(xx.^2+yy.^2);
    
    circ = zeros(size(rr));
    circ(rr>48) = 1;
    circ(rr>100) = 0;

    ima = image(im);
    ima.AlphaData = circ;
    hold on
    plot(48*cos(thetas)+100,48*sin(thetas)+100,'k','LineWidth',2)
    plot(98*cos(thetas)+100,98*sin(thetas)+100,'k','LineWidth',2)
    text(82,110,'\phi','FontSize',24)
    axis off
    axis equal
    set(gca,'YDir','normal','XDir','normal')
    
    thetas = -21*pi/60:pi/20:21*pi/60;
    axes('Units','pixels','Position',[25+300 40 90 90])
    x = -100:100;
    y = -100:100;
    [xx,yy] = meshgrid(x,y);
    angles = atan2(yy,xx);
    im = real2rgb(angles,cmap,[-pi/3 pi/3]);

    rr = sqrt(xx.^2+yy.^2);
    
    circ = zeros(size(rr));
    circ(rr>48) = 1;
    circ(rr>100) = 0;
    circ(angles>pi/3)=0;
    circ(angles<-pi/3)=0;
    
    ima = image(im);
    ima.AlphaData = circ;
    hold on
    plot(48*cos(thetas)+100,48*sin(thetas)+100,'k','LineWidth',2)
    plot(98*cos(thetas)+100,98*sin(thetas)+100,'k','LineWidth',2)
    plot([48*cos(pi/3),98*cos(pi/3)]+100,[48*sin(pi/3),98*sin(pi/3)]+100,'k','LineWidth',2)
    plot([48*cos(-pi/3),98*cos(-pi/3)]+100,[48*sin(-pi/3),98*sin(-pi/3)]+100,'k','LineWidth',2)
    text(82,110,'\phi','FontSize',24)
    axis off
    axis equal
    set(gca,'YDir','normal','XDir','normal')
    
    %% Plot r / theta with phi as a color.
    
    %cmap = 'C1';
    cmap = defdircmap;
    
    thetas = -pi:pi/20:pi;
    rs = 0:10:200;
    [tthetas,rrs] = meshgrid(thetas,rs);
    ppdens = zeros(size(tthetas));
    pndens = zeros(size(tthetas));
    npdens = zeros(size(tthetas));
    nndens = zeros(size(tthetas));

    
    for i = 1:numel(thetas)-1
        for j = 1:numel(rs)-1
            cppas = (ppa<=thetas(i+1)).*(ppa>thetas(i))...
                .*(ppr<=rs(j+1)).*(ppr>rs(j))==1;
            cpnas = (pna<=thetas(i+1)).*(pna>thetas(i))...
                .*(pnr<=rs(j+1)).*(pnr>rs(j))==1;
            cnpas = (npa<=thetas(i+1)).*(npa>thetas(i))...
                .*(npr<=rs(j+1)).*(npr>rs(j))==1;
            cnnas = (nna<=thetas(i+1)).*(nna>thetas(i))...
                .*(nnr<=rs(j+1)).*(nnr>rs(j))==1; 
            
            pnpt = pnp(cpnas);
            pnpt = pnpt((pnpt>-pi/3).*(pnpt<pi/3)==1);
            nnpt = nnp(cnnas);
            nnpt = nnpt((nnpt>-pi/3).*(nnpt<pi/3)==1);
            ppdens(j,i) = angularmean(ppp(cppas));
            pndens(j,i) = angularmean(pnpt*3)/3;
            npdens(j,i) = angularmean(npp(cnpas));
            nndens(j,i) = angularmean(nnpt*3)/3;

        end
    end
    figure('Units','pixels','Position',...
        [200 200 300+300+130+100 300+300+40*3],...
        'PaperUnits','points','PaperPosition',...
        [0 0 300+300+130+100 300+300+40*3],'PaperSize',...
        [300+300+130+100 300+300+40*3])
    
    
    axes('Units','pixels','Position',[50 80+300 300 300],'box','on');
    fill(200*cos(thetas),200*sin(thetas),'k');
    hold on
    h = pcolor(rrs.*cos(tthetas),rrs.*sin(tthetas),ppdens);
    set(h, 'EdgeColor', 'none');
    colormap(cmap)
    axis equal
    axis off
    plot(0,0,'w.','MarkerSize',10);
    plot([0 10],[0 0],'w','LineWidth',1.5);
    plot(200*cos(circt),200*sin(circt),'w','LineWidth',1)
    plot(75*cos(circt),75*sin(circt),'w--','LineWidth',1)
    xlim([-200 200])
    ylim([-200 200])
    
    axes('Units','pixels','Position',[90+300 40 300 300]);
    fill(200*cos(thetas),200*sin(thetas),'k');
    hold on
    h = pcolor(rrs.*cos(tthetas),rrs.*sin(tthetas),pndens);
    set(h, 'EdgeColor', 'none');
    colormap(cmap)
    axis equal
    axis off
    plot(0,0,'w.','MarkerSize',10);
    plot([0 10],[0 0],'w','LineWidth',1.5);
    plot(200*cos(circt),200*sin(circt),'w','LineWidth',1)
    plot(75*cos(circt),75*sin(circt),'w--','LineWidth',1)
    xlim([-200 200])
    ylim([-200 200])
    
    axes('Units','pixels','Position',[90+300 80+300 300 300]);
    fill(200*cos(thetas),200*sin(thetas),'k');
    hold on
    h = pcolor(rrs.*cos(tthetas),rrs.*sin(tthetas),npdens);
    set(h, 'EdgeColor', 'none');
    colormap(cmap)
    axis equal
    axis off
        plot(0,0,'k.','MarkerSize',10);
    quiver([0 0 0],[0 0 0],[10 10*cos(2*pi/3) 10*cos(4*pi/3)],...
        [0 10*sin(2*pi/3) 10*sin(4*pi/3)],'w','AutoScale','off',...
        'ShowArrowHead','off','LineWidth',1.5)
    plot(200*cos(circt),200*sin(circt),'w','LineWidth',1)
    plot(75*cos(circt),75*sin(circt),'w--','LineWidth',1)
    xlim([-200 200])
    ylim([-200 200])
    
    axes('Units','pixels','Position',[50 40 300 300]);
    fill(200*cos(thetas),200*sin(thetas),'k');
    hold on
    h = pcolor(rrs.*cos(tthetas),rrs.*sin(tthetas),nndens);
    set(h, 'EdgeColor', 'none');
    colormap(cmap)
    axis equal
    axis off
        plot(0,0,'k.','MarkerSize',10);
    quiver([0 0 0],[0 0 0],[10 10*cos(2*pi/3) 10*cos(4*pi/3)],...
        [0 10*sin(2*pi/3) 10*sin(4*pi/3)],'w','AutoScale','off',...
        'ShowArrowHead','off','LineWidth',1.5)
    plot(200*cos(circt),200*sin(circt),'w','LineWidth',1)
    plot(75*cos(circt),75*sin(circt),'w--','LineWidth',1)
    xlim([-200 200])
    ylim([-200 200])
    
    eds = -pi:pi/12:pi;
    filt = [1/2 1/2];
    ec = conv(eds,filt,'valid');
    
    ppat = ppa(ppr<75);
    pnat = pna(pnr<75);
    npat = npa(npr<75);
    nnat = nna(nnr<75);
    
    ppac = histcounts(ppat,eds);
    pnac = histcounts(pnat,eds);
    npac = histcounts(npat,eds);
    nnac = histcounts(nnat,eds);
    
    ppac = [ppac ppac(1)];
    pnac = [pnac pnac(1)];
    npac = [npac npac(1)];
    nnac = [nnac nnac(1)];
    ec = [ec ec(1)];
    
    axes('Units','pixels','Position',[50+220 80+300+220 80 80])
    fill(1000*cos(circt),1000*sin(circt),'w')
    hold on
    plot(0,0,'k.','MarkerSize',10)
    plot(3*ppac.*cos(ec),3*ppac.*sin(ec),'r','LineWidth',1.5)
    plot(1000*cos(circt),1000*sin(circt),'k','LineWidth',1)
    axis off
    xlim([-1000 1000])
    ylim([-1000 1000])
    axes('Units','pixels','Position',[90+300+220 40+220 80 80])

    fill(1000*cos(circt),1000*sin(circt),'w')
    hold on
    plot(0,0,'k.','MarkerSize',10)
    plot(pnac.*cos(ec),pnac.*sin(ec),'b','LineWidth',1.5)
    plot(1000*cos(circt),1000*sin(circt),'k','LineWidth',1)
    axis off
    xlim([-1000 1000])
    ylim([-1000 1000])
    
    
    axes('Units','pixels','Position',[90+300+220 80+300+220 80 80])
    fill(1000*cos(circt),1000*sin(circt),'w')
    hold on
    plot(0,0,'k.','MarkerSize',10)
    plot(npac.*cos(ec),npac.*sin(ec),'r','LineWidth',1.5)
    plot(1000*cos(circt),1000*sin(circt),'k','LineWidth',1)
    axis off
    xlim([-1000 1000])
    ylim([-1000 1000])
    
    axes('Units','pixels','Position',[50+220 40+220 80 80])
    fill(1000*cos(circt),1000*sin(circt),'w')
    hold on
    plot(0,0,'k.','MarkerSize',10)
    plot(nnac.*cos(ec)/3,nnac.*sin(ec)/3,'b','LineWidth',1.5)
    plot(1000*cos(circt),1000*sin(circt),'k','LineWidth',1)
    axis off
    xlim([-1000 1000])
    ylim([-1000 1000])    

    axes('Units','pixels','Position',[25+300 80+300 90 90])
    x = -100:100;
    y = -100:100;
    [xx,yy] = meshgrid(x,y);
    angles = atan2(yy,xx);
    im = real2rgb(angles,cmap,[-pi pi]);

    rr = sqrt(xx.^2+yy.^2);
    
    circ = zeros(size(rr));
    circ(rr>48) = 1;
    circ(rr>100) = 0;

    ima = image(im);
    ima.AlphaData = circ;
    hold on
    plot(48*cos(thetas)+100,48*sin(thetas)+100,'k','LineWidth',2)
    plot(98*cos(thetas)+100,98*sin(thetas)+100,'k','LineWidth',2)
    text(82,110,'\phi','FontSize',24)
    axis off
    axis equal
    set(gca,'YDir','normal','XDir','normal')
    
    thetas = -21*pi/60:pi/20:21*pi/60;
    axes('Units','pixels','Position',[25+300 40 90 90])
    x = -100:100;
    y = -100:100;
    [xx,yy] = meshgrid(x,y);
    angles = atan2(yy,xx);
    im = real2rgb(angles,cmap,[-pi/3 pi/3]);

    rr = sqrt(xx.^2+yy.^2);
    
    circ = zeros(size(rr));
    circ(rr>48) = 1;
    circ(rr>100) = 0;
    circ(angles>pi/3)=0;
    circ(angles<-pi/3)=0;
    
    ima = image(im);
    ima.AlphaData = circ;
    hold on
    plot(48*cos(thetas)+100,48*sin(thetas)+100,'k','LineWidth',2)
    plot(98*cos(thetas)+100,98*sin(thetas)+100,'k','LineWidth',2)
    plot([48*cos(pi/3),98*cos(pi/3)]+100,[48*sin(pi/3),98*sin(pi/3)]+100,'k','LineWidth',2)
    plot([48*cos(-pi/3),98*cos(-pi/3)]+100,[48*sin(-pi/3),98*sin(-pi/3)]+100,'k','LineWidth',2)
    text(82,110,'\phi','FontSize',24)
    axis off
    axis equal
    set(gca,'YDir','normal','XDir','normal')
    
end
