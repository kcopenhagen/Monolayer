function S0 = SPhysLC(dfield,a)  %Local S, in boxes of edge size a.

    change = round(rand(size(dfield)));
    dfield(change==1) = dfield(change==1)+pi;
    
    x = 0.133*(1:numel(dfield(1,:)));
    y = 0.133*(1:numel(dfield(:,1)));
    
    [x,y] = meshgrid(x,y);
    
    xsubs=round(x*1/a-min(x(:)*1/a)+1);
    ysubs=round(y*1/a-min(y(:)*1/a)+1);

    subs = sub2ind(size(dfield),ysubs,xsubs);
    S = accumarray(subs(:),dfield(:),[],@calcS);

    S0 = S(subs);
    %S0 = mean(S(subs),'all');
end