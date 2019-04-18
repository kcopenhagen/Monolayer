function eds = layeredges(fpath, t, sfactor, clsize)
    
    h = heightdata(fpath,t);
    hs = imgaussfilt(h,64);
    h = h-hs;
    h = imgaussfilt(h,1);
    edt = edge(h,'Sobel',sfactor,'nothinning');
    se = strel('disk',clsize);
    eds = imclose(edt,se);
    
end