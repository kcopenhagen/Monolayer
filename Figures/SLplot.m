function slim = SLplot(dfield, dr, l)

nhits = zeros(round(size(dfield)/dr)+1);
% 
% show(dfield)
% colormap(orientcmap)
% blank = zeros(size(dfield));
% show(blank)
% set(gca,'CLim',[-1 0])
% hold on
dfieldt = dfield+pi;
mask = zeros(size(dfield));
aslinds = [];
%%
ind = find(nhits==0,1);

while ~isempty(ind)
    %%
    [yy,xx] = ind2sub(size(nhits),ind);
%     dx = randi(dr-1);
%     dy = randi(dr-1);
    dx = round(dr/2);
    dy = round(dr/2);
    x = dr*(xx-1)+dx;
    y = dr*(yy-1)+dy;
    while (x>1024 || y>768)
%         dx = randi(dr-1);
%         dy = randi(dr-1);
        x = dr*(xx-1)+dx;
        y = dr*(yy-1)+dy;
    end

    
    sld1 = sl(cos(dfield),sin(dfield), [x, y], l);
    sld2 = sl(cos(dfieldt),sin(dfieldt), [x, y], l);

    sld1ies = round(sld1);
    sld2ies = round(sld2);

    sld1ies(isnan(sld1ies(:,1)),:) = []; 
    sld2ies(isnan(sld2ies(:,1)),:) = []; 
    
    sld1ies(sld1ies(:,1)>1024,1) = 1024;
    sld2ies(sld2ies(:,1)>1024,1) = 1024;
    sld1ies(sld1ies(:,2)>768,2) = 768;
    sld2ies(sld2ies(:,2)>768,2) = 768;
    
    sld1ies(sld1ies(:,1)<1,1) = 1;
    sld2ies(sld2ies(:,1)<1,1) = 1;
    sld1ies(sld1ies(:,2)<1,2) = 1;
    sld2ies(sld2ies(:,2)<1,2) = 1;
    
    sl1inds = sub2ind(size(mask),sld1ies(:,2),sld1ies(:,1));
    sl2inds = sub2ind(size(mask),sld2ies(:,2),sld2ies(:,1));
    
    aslinds = [aslinds; sl1inds; sl2inds];
    
    sld1s = floor((sld1)/dr)+1;
    sld2s = floor((sld2)/dr)+1;

%     
%     plot(sld1(:,1),sld1(:,2),'k','LineWidth',1)
%     plot(sld2(:,1),sld2(:,2),'k','LineWidth',1)
%     

    s1inds = sub2ind(size(nhits),sld1s(:,2),...
        sld1s(:,1));
    [a, b] = histcounts(s1inds,'BinMethod','integer');
    b = b+0.5;
    b(end) = [];
    nhits(b) = nhits(b) + a;
    s2inds = sub2ind(size(nhits),sld2s(:,2),...
        sld2s(:,1));
    [a, b] = histcounts(s2inds,'BinMethod','integer');
    b = b+0.5;
    b(end) = [];
    nhits(b) = nhits(b) + a;
    
    ind = find(nhits==0,1);

%     drawnow
end

mask(aslinds) = 1;
% show(mask)
% toc
slim = mask;