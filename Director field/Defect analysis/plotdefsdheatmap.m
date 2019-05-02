function plotdefsdheatmap(datapath)

if ~all([exist('dr') exist('dt') exist('qq')])
    [dr, dt, qq] = defmsd(datapath);
end

ldt = log10(dt(dr>0));
ldr = log10(dr(dr>0));

nbins = 50;

phm = zeros(nbins+1);
nhm = zeros(nbins+1);

dldt = (max(ldt)-min(ldt))/nbins;
dldr = (max(ldr)-min(ldr))/nbins;

is = round((ldt(qq(dr>0)>0)-min(ldt))/dldt);
js = round((ldr(qq(dr>0)>0)-min(ldr))/dldr);

sz = size(phm);

inds = sub2ind(sz,js+1,is+1);

A = accumarray(inds,ones(size(inds)));

phm(unique(inds)) = A(unique(inds));

is = round((ldt(qq(dr>0)<0)-min(ldt))/dldt);
js = round((ldr(qq(dr>0)<0)-min(ldr))/dldr);

sz = size(phm);

inds = sub2ind(sz,js+1,is+1);

A = accumarray(inds,ones(size(inds)));

nhm(unique(inds)) = A(unique(inds));

phmn = normalise(phm);
nhmn = normalise(nhm);

f = figure('Units','pixels','Position',[100 200 540 460]);
ax = axes(f,'Units','pixels','Position',[110 50 400 400]);

im = zeros(nbins+1,nbins+1,3);
im(:,:,1) = phmn;
im(:,:,3) = nhmn;
image(im)
set(gca,'YDir','normal','FontSize',16,'FontWeight','normal','FontName','Helvetica');
xticks(1:round(nbins/5):nbins+1);
yticks(1:round(nbins/5):nbins+1);
xticklabels(10.^(min(ldt)+dldt*(1:round(nbins/5):nbins+1)))
yticklabels(10.^(min(ldr)+dldr*(1:round(nbins/5):nbins+1)))

xlabel('\tau (s)');
ylabel('\langle \Deltar(\tau)^2 \rangle (\mum^2)');
