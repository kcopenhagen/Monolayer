% Flow divergence plots

for n = 31

pavgvxsm = imgaussfilt(pavgvx,n);
pavgvysm = imgaussfilt(pavgvy,n);
pdiv = divergence(pavgvxsm,pavgvysm);

navgvxsm = imgaussfilt(navgvx,n);
navgvysm = imgaussfilt(navgvy,n);
ndiv = divergence(navgvxsm,navgvysm);

show(pdiv)
colorcet('D1')
caxis([-1e-4 1e-4])

show(ndiv)
colorcet('D1')
caxis([-1e-4 1e-4])

end
% show(curl(pavgvx,pavgvy))
% colorcet('D2')
% caxis([-2e-4 2e-4])
% 
% show(curl(navgvx,navgvy))
% colorcet('D2')
% caxis([-2e-4 2e-4])