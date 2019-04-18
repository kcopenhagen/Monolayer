function [laylab, dhs] = layersbystep(mask, surrs, layer, h, XYcal, hl)
    CC = bwconncomp(surrs);
    P = regionprops(CC,'PixelIdxList','Area');
    P([P.Area]<2/(XYcal*XYcal))=[];
    l = round(5/XYcal);
    se = strel('disk',l);
    avglay = 0;
    count = 0;
    dhs = [];

    for i = 1:numel(P)
        %Mask of the surrounding area in question.
        surrmask = zeros(size(layer));
        surrmask(P(i).PixelIdxList)=1;
        %Mask of the original area that is close to surrounding area in
        %question.
        smask = imdilate(surrmask,se);
        smask(surrs==1)=0;
        smask(mask==0)=0;
        dh = mean(h(smask==1))-mean(h(surrmask==1));
        dhs = [dhs dh];
%        avglay = avglay + (numel(smask==1)+numel(surrmask==1))...
%            *round(layer(P(i).PixelIdxList(1))+2.3436*dh);
        avglay = avglay + (numel(smask==1)+numel(surrmask==1))...
            *round(layer(P(i).PixelIdxList(1))+0.5/hl*dh);
        count = count + (numel(smask==1)+numel(surrmask==1));
    end
    laylab = round(avglay/count);
end

