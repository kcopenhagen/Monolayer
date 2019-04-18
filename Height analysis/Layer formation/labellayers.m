function alldifs = labellayers(fpath,sf,cl)
    
    t = input('Starting time: ');
    alldifs = {[],[],[],[]};
    br = false;
    while t>0
        XYcal = getXYcal(fpath);
        
        edges = layeredges(fpath,t,sf,cl);
        layer = NaN(size(edges));
        layer(edges==0) = 1;

        h = heightdata(fpath,t);
        hs = imgaussfilt(h,64);
        h = h-hs;
        overlaymaskimr(h,h,h);
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
                        overlaymaskimr(h,nearsurr,surrst);
                        ll = menu('Green is ____ than red','Higher','Same','Lower','Cant tell','Finish');
                        close all
                        hdif = mean(mean(h(Propsurrs(j).PixelIdxList)))...
                            -mean(mean(h(nearsurr==1)));
                        if (ll == 5)
                            br = true;
                            break;
                        end
                        alldifs{ll} = [alldifs{ll} hdif];
                        f = figure('Position',[800 500 1008/2 752/2]);
                        ed = -0.75:0.025:0.75;
                        histogram(alldifs{1},ed);
                        hold on
                        histogram(alldifs{2},ed);
                        histogram(alldifs{3},ed);
                    end
                    %alldifs = [alldifs hdif];
                end
                if br
                    break
                end
            end

        end
        if br
            break
        end
        t = input('Enter next time (-1 to end)');
    end
    
%     nd = histcounts(alldifs{1},ed);
%     ns = histcounts(alldifs{2},ed);
%     nu = histcounts(alldifs{3},ed);
%     
%     newed = ed(2:end)-(ed(2)-ed(1))/2;
%     ndf = fit(newed',nd','gauss1');
%     nsf = fit(newed',ns','gauss1');
%     nuf = fit(newed',nu','gauss1');
%     figure(f)
%     plot(ndf,'b');
%     hold on
%     plot(nsf,'o');
%     plot(nuf,'y');
%     xl = xlim;
%     yl = ylim;
%     
%     dh = (abs(ndf.b1)+abs(nuf.b1))/4;
%     
%     plot([-dh -dh],[-10000 1000000],'k--');
%     plot([dh dh],[-10000 1000000],'k--');
%     xlim(xl);
%     ylim(yl);
%     
end