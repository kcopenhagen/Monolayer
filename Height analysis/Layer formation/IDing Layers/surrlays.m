function [mask, surrs] = surrlays(P,layers,XYcal)

    r = round(5/XYcal);
    mask = zeros(size(layers));
    mask(P.PixelIdxList)=1;
    
    se = strel('disk',r);
    
    surrs = imdilate(mask,se);
    surrs(mask==1)=0;
    
end