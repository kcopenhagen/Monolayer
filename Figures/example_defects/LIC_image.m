function [im, nhits] = LIC_image(vx,vy)
    %Computes LIC of vector field v with size sz. If v is smaller than sz
    %it interpolates v to fill space.
    tic
    sz = size(vx);
    T = rand(sz);
    N = 1;
    slc = 0;
    boxedge = min(sz)/10;
    M = 50;
    n = 20;
    L = 2*(M+n);

    im = zeros(sz(1),sz(2));
    nhits = zeros(size(T));
    x = 1:sz(2);
    y = 1:sz(1);
    [xx, yy] = meshgrid(x,y);
    
    indst = 1:numel(im);
    
    chunkinds = zeros(numel(im),1);
    chdx = 40;
    count = 1;
    for ci = 0:chdx-1
        for cj = 0:chdx-1
            for i = 1:chdx:sz(2)
                for j = 1:chdx:sz(1)
                    col = i+ci;
                    row = j+cj;
                    if (row<=sz(1) && col<=sz(2))
                        chunkinds(count) = sub2ind(size(im),row,col);
                        count = count+1;
                    end
                end
            end
        end
    end
    
    for i = 1:numel(chunkinds)
        if (nhits(chunkinds(i))<N)
            x = xx(chunkinds(i));
            y = yy(chunkinds(i));

            slr = sl(vx, vy, [x, y], L);
            slr(slr(:,1)<1,:) = [];
            slr(slr(:,2)<1,:) = [];
            slr(slr(:,1)>numel(im),:) = [];
            slr(slr(:,2)>numel(im),:) = [];
            slc = slc+1;

            ind0 = sub2ind(sz,y,x);

            inds = sub2ind(sz,round(slr(:,2)),round(slr(:,1)));
            inds(isnan(inds))=[];

            u0 = find(inds==ind0,1);

            ui = u0-n:u0+n;
            ui(ui<1) = [];
            ui(ui>numel(inds)) = [];

            I0 = 1/numel(ui)*nansum(T(round(inds(ui))));

            im(ind0) = im(ind0) + I0;

            nhits(ind0) = nhits(ind0)+1;
            indst(indst==ind0) = [];
            I0t = I0;
            for iM = 1:M
                u0t = u0+iM;
                if (u0t+n+1<numel(inds) && u0t-n>0)
                    Icorr = T(inds(u0t+n+1))-T(inds(u0t-n));
                    I0t = I0t + 1/numel(ui)*Icorr;
                    im(inds(u0t)) = im(inds(u0t))+I0t;
                    nhits(inds(u0t)) = nhits(inds(u0t))+1;

                else
                    break;
                end
            end
            I0t = I0;
            for iM = -1:-M
                u0t = u0+iM;
                if (u0t-n-1>0 && u0t+n<numel(inds))
                    Icorr = T(inds(u0t-n-1))-T(inds(u0t+n));
                    I0t = I0t+1/numel(ui)*Icorr;
                    im(inds(u0t)) = im(inds(u0t)) + I0t;
                    nhits(inds(u0t)) = nhits(inds(u0t))+1;

                else 
                    break
                end
            end
        end
    end
    im = im./nhits;
    toc
    slc
end
    