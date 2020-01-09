function S = Sfield(dfield,a) 
% Calculate S for all pixels of dfield, with a box size of a microns

%%
r = round(a/0.133);

se = strel('disk',r);
%mf = se.Neighborhood/sum(se.Neighborhood,'all');
mf = se.Neighborhood;
norm = conv2(ones(size(dfield)),mf,'same');

dfield2 = 2*dfield;
dx2 = cos(dfield2);
dy2 = sin(dfield2);

mdx2 = conv2(dx2,mf,'same')./norm;
mdy2 = conv2(dy2,mf,'same')./norm;

mdf = atan2(mdy2,mdx2)/2;

%Prefered direction (n).
nx = cos(mdf);
ny = sin(mdf);

%Director field mean over areas.
dx = cos(dfield);
dy = sin(dfield);

mdxdx = conv2(dx.*dx,mf,'same')./norm;
mdxdy = conv2(dx.*dy,mf,'same')./norm;
mdydy = conv2(dy.*dy,mf,'same')./norm;

S = (2*(nx.*nx.*mdxdx+2*nx.*ny.*mdxdy+ny.*ny.*mdydy)-1);

% S(1:r,:) = NaN;
% S(:,1:r) = NaN;
% S(end-r+1:end,:) = NaN;
% S(:,end-r+1:end) = NaN;

