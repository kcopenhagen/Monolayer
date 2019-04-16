function defsinholes
folders = dir('/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Data');
dirFlags = [folders.isdir];
folders = folders(dirFlags);
folders(1:2) = [];

f = randi(numel(folders),1);
fpath = [folders(f).folder '/' folders(f).name '/'];
files = dir([fpath 'Laser/']);
dirFlags = [files.isdir];
files = files(~dirFlags);

N = numel(files);
t = randi(N,1);

lays = loaddata(fpath,t,'manuallayers','int8');
lays = round(imgaussfilt(lays,3));

holes1 = lays == 0;
holes2 = holes1;
CC = bwconncomp(holes1);
P = regionprops(CC,'PixelIdxList','MinorAxisLength');
Ps = P([P.MinorAxisLength]<39);

for i = 1:numel(Ps)
    holes2(Ps(i).PixelIdxList) = 0;
end

dir = loaddata(fpath,t,'dfield','float');
l = laserdata(fpath,t);

im = real2rgb(dir,orientcmap);

l = l./imgaussfilt(l,64);
l = normalise(l);

im = im.*l*1.6;
im(im>1) = 1;

alled = edge(holes1);
baded = edge(holes2);
se = strel('disk',2);
alled = imdilate(alled,se);
baded = imdilate(baded,se);

imr = im(:,:,1);
img = im(:,:,2);
imb = im(:,:,3);

imr(alled) = 1;
img(alled) = 1;
imb(alled) = 1;

imr(baded) = 0;
img(baded) = 0;
imb(baded) = 0;

im(:,:,1) = imr;
im(:,:,2) = img;
im(:,:,3) = imb;

show(im)

[x,y,~,~] = finddefects(fpath,t);
hold on
plot(x,y,'k.','MarkerSize',20)
plot(x,y,'w.','MarkerSize',12)