function q = regioncharge(Ph,dir)

%%
sz = size(dir);
mask = zeros(sz);
mask(Ph.PixelIdxList) = 1;

B = bwboundaries(mask,'noholes');
B = B{1};


inds = sub2ind(sz,B(:,1),B(:,2));

angs = dir(inds);
angs = [angs; angs(1)];
dangs = conv(angs,[1 -1],'valid');
dangs(dangs>pi/2) = dangs(dangs>pi/2) - pi;
dangs(dangs<-pi/2) = dangs(dangs<-pi/2) + pi;

q = sum(dangs)/(2*pi);
