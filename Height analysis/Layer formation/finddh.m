function dhs = finddh(fpath,sf,cl,dt)
    files = dir([fpath 'Height/']);
    dirFlags = [files.isdir];
    files = files(~dirFlags);
    t = numel(files);
    
    XYcal = getXYcal(fpath);

    %t = input('Starting time: ');
    dhs = [];
    while t>0
        edges = layeredges(fpath,t,sf,cl);
        layer = NaN(size(edges));
        layer(edges==0) = 1;

        h = heightdata(fpath,t);
        hs = imgaussfilt(h,64);
        h = h-hs;
        
        CC = bwconncomp(edges==0);
        P = regionprops(CC,'PixelIdxList','Area');
        P([P.Area]<1/(XYcal*XYcal)) = [];
        [~,ind] = sort([P.Area],'descend');
        P = P(ind);
        
        for i = 1:numel(P)
            [P(i).mask, P(i).surrs] = surrlays(P(i),layer,XYcal);
        end
        
        if ~isempty(P)

            for i = 1:numel(P)
                %mask = zeros(size(edges));
                mask = P(i).mask;
                surrs = P(i).surrs;
                surrs(isnan(layer)) = 0;
                CC = bwconncomp(surrs);
                Propsurrs = regionprops(CC,'PixelIdxList');
                for j = 1:numel(Propsurrs)
                    se = strel('disk',round(5/XYcal));
                    surrst = zeros(size(mask));
                    surrst(Propsurrs(j).PixelIdxList) = 1;
                    nearsurr = imdilate(surrst,se);
                    nearsurr(mask~=1) = 0;
                    if sum(nearsurr(:))>100 && sum(surrst(:))>100

                        hdif = mean(mean(h(Propsurrs(j).PixelIdxList)))...
                            -mean(mean(h(nearsurr==1)));
                        dhs = [dhs; hdif];

                    end
                end
            end
        end
        t=t-dt;
    end
    

    
end