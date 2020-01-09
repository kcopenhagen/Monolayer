
%%
fpaths = getfold(datapath);
f = 2;
fpath = fpaths{f};
adefs = alldefects(fpath);

ids = unique([adefs.id]);

figure

%%

pdefs = adefs([adefs.q]>0);
ndefs = adefs([adefs.q]<0);

i = randi(numel(pdefs),1);

dfield = loaddata(fpath,pdefs(i).ts,'dfield','float');

as = (1:20)*0.133;
x = 1:1024;
y = 1:768;
[xx, yy] = meshgrid(x,y);

for a = as
    S = Sfield(dfield,a);
    rx = xx-pdefs(i).x;
    ry = yy-pdefs(i).y;
    
    r = sqrt(rx.^2+ry.^2);
    
    subs = round(r)+1;
    mS = accumarray(subs(:),S(:),[],@mean);
    mr = accumarray(subs(:),r(:),[],@mean);
    plot(mr*0.133,mS);
    hold on
    
    
end
    
    
    
