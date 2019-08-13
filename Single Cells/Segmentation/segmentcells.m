function cells = segmentcells(lBW)

    %%
    CC = bwconncomp(lBW);
    cells = regionprops(CC,'PixelIdxList','Area','MajorAxisLength','MinorAxisLength','Centroid','Perimeter');
    
%     scatter([cells.MajorAxisLength],[cells.Perimeter]./[cells.Area])
%     figure
%     scatter([cells.Area],[cells.Perimeter]./[cells.Area])
    %%
    mask = zeros(size(lBW));
    good = ones(1,numel(cells));
    
    good([cells.Perimeter]./[cells.Area]>0.55)=0;


    cells = cells(good == 1);
    
    maskall = zeros(size(lBW));
    for i = 1:numel(cells)
        mask = zeros(size(lBW));
        mask([cells(i).PixelIdxList]) = 1;
        se = strel('disk',6);
        mask = imdilate(mask,se);
        maskall = maskall+mask;
    end
%     
%      overlaymaskimr(maskall,lBW)
    %%
    good = ones(numel(cells),1);
    
    for i = 1:numel(cells)
        mask = zeros(size(lBW));
        mask([cells(i).PixelIdxList]) = 1;
        se = strel('disk',6);
        mask = imdilate(mask,se);
        if sum(sum((maskall>1).*mask))>0
            good(i) = 0;
        end
    end
    good([cells.Perimeter]./[cells.Area]<0.35)=0;
    good([cells.Area]>350) = 0;
    cells = cells(good==1);
%     maskall = zeros(size(lBW));
%     for i = 1:numel(cells)
%         mask = zeros(size(lBW));
%         mask([cells(i).PixelIdxList]) = 1;
%         maskall = maskall+mask;
%     end
%     overlaymaskimr(normalise(l./imgaussfilt(l,64)),maskall);
%     
%     overlaymaskimr(normalise(l./imgaussfilt(l,64)),mask,lBW);
%     
    
end