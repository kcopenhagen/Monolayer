function [sfactors, clsizes, sffs, clfs, sfps, clps, pn] = edgevals(fpath)

    files = dir([fpath 'Height/']);
    dirFlags = [files.isdir];
    files = files(~dirFlags);
    N = numel(files);
    del = [];

    for t = 1:N
        if files(t).name(1) == '.'
            del = [del; t];
        end
    end
    files(del) = [];
    N = numel(files);
    
    sfactors = [];
    clsizes = [];
    sffs = [];
    clfs = [];
    sfps = [];
    clps = [];
    cont = true;
    pn = [];
    while cont
        t = randi(N,1);
        figure
        set(gcf,'Visible','on');
        scatter(sfps,clps,pn,'g','filled')
        hold on
        plot(sfactors,clsizes,'b.','MarkerSize',10)
        plot(sffs,clfs,'r.','MarkerSize',10);
        xlim([0.005 0.015]);
        ylim([1 6]);
        xlabel('Edge threshold');
        ylabel('imclose disk radius');
        
        [sfactor, clsize] = ginput(1);
        clsize = round(clsize);
        close all

        l = laserdata(fpath,t);
        ed = layeredges(fpath, t, sfactor, clsize);
        
        overlaymaskimr(l,ed);
        set(gcf,'Visible','on');
        ok = menu('Do the edges work?','Perf','Yes','No','Plot','Finish');
        close all
        if (ok == 1)
            sfps = [sfps; sfactor];
            clps = [clps; clsize];
            CC = bwconncomp(~ed,8);
            P = regionprops(CC);
            pn = [pn; numel(P)];
        elseif (ok == 2)
            sfactors = [sfactors; sfactor];
            clsizes = [clsizes; clsize];
        elseif (ok == 3)
            sffs = [sffs; sfactor];
            clfs = [clfs; clsize];
        elseif (ok == 4)
            figure
            set(gcf,'Visible','on');
            scatter(sfps,clps,pn,'g','filled')
            hold on
            plot(sfactors,clsizes,'b.','MarkerSize',10)
            plot(sffs,clfs,'r.','MarkerSize',10);
            xlim([0.005 0.015]);
            ylim([1 6]);
        elseif (ok == 5)
            cont = false;
        end
    end
end

% sfactor = 0.011;
% clsize = 5;





