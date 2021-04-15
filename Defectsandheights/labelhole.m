function [id,holes] = labelhole(i,id,holes)

    holes(i).id = id;
    t = holes(i).t;
    fpath = holes(i).fpath;
    
    inex = arrayfun(@(x)eq(string(fpath),string(x.fpath)),holes);
    intp1 = [holes.t]==t+1;
    intm1 = [holes.t]==t-1;
    inpix = arrayfun(@(x)sum(ismember([x.pix],[holes(i).pix]))>0,holes);
    
    trnext = inex.*intp1.*inpix;
    trprev = inex.*intm1.*inpix;

    
    js = find(trnext+trprev);
    
    for j = js
        if holes(j).id == -1
            [id, holes] = labelhole(j,id,holes);
        elseif holes(j).id ~= id
            unlabid = holes(j).id;
            unlab = find([holes.id]==unlabid);
            for k = unlab
                holes(k).id = -1;
            end
            [id, holes] = labelhole(j,id,holes);
        end
    end
    
end