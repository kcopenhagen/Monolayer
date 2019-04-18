function findlayers(fpath, t, hl, sf, cl)

    if nargin<3
        hl = 0.1616;
    end
    [~,~,~] = mkdir([fpath 'analysis/layers']);
    l = laserdata(fpath,t);
    h = heightdata(fpath,t);
    hs = imgaussfilt(h,64);
    h = h-hs;
    
    XYcal = getXYcal(fpath);
    name = sprintf('%06d.bin',t-1);
    dhs = [];
    dhst=[];
    x = 1:numel(h(1,:));
    y = 1:numel(h(:,1));
    
    [xx, yy] = meshgrid(x,y);


    layer = NaN(size(h));

    ed = layeredges(fpath,t,sf,cl);
    
    CC = bwconncomp(ed==0);
    P = regionprops(CC,'Area','PixelIdxList');
    P([P.Area]<1/(XYcal*XYcal)) = [];

    for i = 1:numel(P)
        [P(i).mask, P(i).surrs] = surrlays(P(i),layer,XYcal);
    end
    
    while ~isempty(P)
        numel(P);
        mi = 0;
        mrat = 0;
        for i = 1:numel(P)
            mask = P(i).mask;
            surrs = P(i).surrs;
            % Take mask of surrounding area and remove edges from it.
            
            surrs(isnan(layer)) = 0;
            if (sum(sum(surrs==1))/sum(sum(mask==1)))>mrat
                mrat = (sum(sum(surrs==1))/sum(sum(mask==1)));
                mi = i;
                msurrs = surrs;
                mmask = mask;
            end
        end
        %Calculate the most likely label for the layer with the highest
        % ratio of labeled surrounding area to mask size..
        if mi~=0
            [clay, dhst] = layersbystep(mmask, msurrs, layer, h, XYcal, hl);
        else
            [~,mi] = max([P.Area]);
            mmask = P(mi).mask;
            msurrs = P(mi).surrs;
            clay = 1;
        end
        dhs = [dhs dhst];
        layer(mmask==1)=clay;
        P(mi) = [];
    end
    alllays = unique(layer(~isnan(layer(:))));
    addlay = NaN(size(layer));

    for i = 1:numel(alllays)
        curlay = alllays(i);
        mask = zeros(size(layer));
        mask(layer==curlay) = 1;
        CC = bwconncomp(mask);
        P = regionprops(CC,'PixelIdxList');
        
        for j = 1:numel(P)
            maskP = zeros(size(layer));
            maskP(P(j).PixelIdxList)=1;
            se = strel('disk',round(5/XYcal));
            maskPdil = imdilate(maskP,se);
            surfsur = fit([xx(maskP==1),yy(maskP==1)],h(maskP==1),'poly11');
            B = surfsur(xx,yy);
            dh = h-B;
            pot = abs(dh)<hl;
            addlaytemp = pot.*maskPdil;
            addlaytemp(addlaytemp==0)=NaN;
            addlaytemp(~isnan(layer))=NaN;
            addlaytemp(P(j).PixelIdxList) = 1;
            CC = bwconncomp(~isnan(addlaytemp));
            P2 = regionprops(CC,'Area','PixelIdxList');
            [~,ind] = max([P2.Area]);
            addlaytemp = NaN(size(layer));
            addlaytemp(P2(ind).PixelIdxList) = 1;
            addlay(addlaytemp==1)=curlay;
        end
    end
    
    layer(~isnan(addlay))=addlay(~isnan(addlay));
    layer(l<1e4)=NaN;
    
    xq = xx(isnan(layer));
    yq = yy(isnan(layer));
    x = xx(~isnan(layer));
    y = yy(~isnan(layer));
    Lq = griddata(x,y,layer(~isnan(layer)),xq,yq,'nearest');
    layer(isnan(layer)) = Lq;

    fID = fopen([fpath 'analysis/layers/' name],'w');
    fwrite(fID,layer,'int8');
    fclose(fID);
    
end

       