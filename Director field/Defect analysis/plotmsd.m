

[dt, dr, qq] = defmsd(datapath);

subs = round(log(dt)*3)+1;
%subs = round(dt/120)+1;
pmsd = accumarray(subs(qq>0),dr(qq>0),[],@mean);
nmsd = accumarray(subs(qq<0),dr(qq<0),[],@mean);
pcount = accumarray(subs(qq>0),1);
ncount = accumarray(subs(qq<0),1);
pstd = accumarray(subs(qq>0),dr(qq>0),[],@std);
nstd = accumarray(subs(qq<0),dr(qq<0),[],@std);

drpdn = accumarray(subs(qq>0),dr(qq>0),[],@(q) quantile(q,0.75));
drpup = accumarray(subs(qq>0),dr(qq>0),[],@(q) quantile(q,0.25));
drndn = accumarray(subs(qq<0),dr(qq<0),[],@(q) quantile(q,0.75));
drnup = accumarray(subs(qq<0),dr(qq<0),[],@(q) quantile(q,0.25));

pdt = accumarray(subs(qq>0),dt(qq>0),[],@mean);
ndt = accumarray(subs(qq<0),dt(qq<0),[],@mean);

drpup(pdt==0) = [];
drpdn(pdt==0) = [];
drnup(ndt==0) = [];
drndn(ndt==0) = [];
pmsd(pdt==0) = [];
nmsd(ndt==0) = [];
pdt(pdt==0) = [];
ndt(ndt==0) = [];

pfit = fit(pdt,pmsd,'power1');
nfit = fit(ndt,nmsd,'power1');

% 
% pfit = fit(dt(qq>0),(dr(qq>0)).^2,'power1');
% nfit = fit(dt(qq<0),(dr(qq<0)).^2,'power1');

fill([pdt; pdt(end:-1:1)],[drpdn; drpup(end:-1:1)],'r','FaceAlpha',0.3,'EdgeColor','r','LineWidth',1);
hold on
fill([ndt; ndt(end:-1:1)],[drndn; drnup(end:-1:1)],'b','FaceAlpha',0.3,'EdgeColor','b','LineWidth',1);
plot(pdt,pmsd,'r','LineWidth',2);
hold on
plot(ndt,nmsd,'b','LineWidth',2);
% plot(pdt,pfit.a*pdt.^pfit.b,'r--','LineWidth',2);
% plot(ndt,nfit.a*ndt.^nfit.b,'b--','LineWidth',2);
% 
% scatter(dt(qq>0),dr(qq>0).^2,'r.','MarkerEdgeAlpha',0.1)
% hold on
% scatter(dt(qq<0),dr(qq<0).^2,'b.','MarkerEdgeAlpha',0.1)
xex2 = [60 260];
yex2 = 0.002*xex2.^2;
xex1 = [60 260];
yex1 = 0.002*xex1.^1;
plot(xex2,yex2,'k','LineWidth',2);
plot(xex1,yex1,'k','LineWidth',2);
set(gca,'Yscale','log','Xscale','log');
