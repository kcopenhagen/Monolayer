function lBW = lbinarize(l)
   
    %% 
    %l = laserdata(fpath,150);
    l2 = l./imgaussfilt(l,32);
    l3 = imopen(imbinarize(normalise(l2),'adaptive','Sensitivity',0.4),strel('disk',1));
    lBW = imdilate(l3,strel('disk',1));
    lBW = round(imgaussfilt(double(lBW),2));
    %overlaymaskimr(normalise(l2),lBW)
end