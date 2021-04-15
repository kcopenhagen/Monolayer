function slim = SLplotgrid(dfield, dr, l)

dfieldt = dfield+pi;
mask = zeros(size(dfield));
aslinds = [];
%%
sz = size(mask);
x = round(dr/2):dr:sz(2);
y = round(dr/2):dr:sz(1);
[xx, yy] = meshgrid(x,y);

for i = 1:numel(xx)
    x = xx(i);
    y = yy(i);
    
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
    
end

mask(aslinds) = 1;
% show(mask)
% toc
slim = mask;