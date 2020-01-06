function dfieldcbar

%% Make a circular colorbar for directors
x = -100:100;
y = 0:100;
[xx,yy] = meshgrid(x,y);

angles = atan(yy./xx);
im = real2rgb(angles,orientcmap);

rr = sqrt(xx.^2+yy.^2);
circ = zeros(size(rr));
circ(rr>50) = 1;
circ(rr>98) = 0;
circ(1:2,1:52) = 0;
circ(1:2,150:200) = 0;

circ2 = zeros(size(rr));
circ2(rr>48) = 1;
circ2(rr>100) = 0;

imr = im(:,:,1);
img = im(:,:,2);
imb = im(:,:,3);

imr(circ==0) = 0;
img(circ==0) = 0;
imb(circ==0) = 0;

imr(circ2==0) = 1;
img(circ2==0) = 1;
imb(circ2==0) = 1;

im(:,:,1) = imr;
im(:,:,2) = img;
im(:,:,3) = imb;

show(im)
set(gca,'YDir','normal','XDir','reverse')

%% Make a colorbar for defect phis

x = -100:100;
y = -100:100;
[xx,yy] = meshgrid(x,y);

angles = atan(yy./xx);
im = real2rgb(angles,defdircmap,[-pi/3 pi/3]);

rr = sqrt(xx.^2+yy.^2);
circ = zeros(size(rr));
circ(rr>50) = 1;
circ(rr>98) = 0;
circ(angles<-pi/3) = 0;
circ(angles>pi/3) = 0;
circ(xx>0) = 0;

circ2 = zeros(size(rr));
circ2(rr>48) = 1;
circ2(rr>100) = 0;
circ2(angles<-pi/3-0.03) = 0;
circ2(angles>pi/3+0.03) = 0;
circ2(xx>0) = 0;

imr = im(:,:,1);
img = im(:,:,2);
imb = im(:,:,3);

imr(circ==0) = 0;
img(circ==0) = 0;
imb(circ==0) = 0;

imr(circ2==0) = 1;
img(circ2==0) = 1;
imb(circ2==0) = 1;

im(:,:,1) = imr;
im(:,:,2) = img;
im(:,:,3) = imb;

show(im)
set(gca,'YDir','normal','XDir','reverse')

%% Same as above but -pi to pi
x = -100:100;
y = -100:100;
[xx,yy] = meshgrid(x,y);
figure
angles = atan2(yy,xx);
im = real2rgb(angles,defdircmap,[-pi pi]);

rr = sqrt(xx.^2+yy.^2);
circ = zeros(size(rr));
circ(rr>50) = 1;
circ(rr>98) = 0;


circ2 = zeros(size(rr));
circ2(rr>48) = 1;
circ2(rr>100) = 0;


imr = im(:,:,1);
img = im(:,:,2);
imb = im(:,:,3);

imr(circ==0) = 0;
img(circ==0) = 0;
imb(circ==0) = 0;

imr(circ2==0) = 1;
img(circ2==0) = 1;
imb(circ2==0) = 1;

im(:,:,1) = imr;
im(:,:,2) = img;
im(:,:,3) = imb;

ima = image(im);
ima.AlphaData = circ2;
axis off
axis equal
set(gca,'YDir','normal','XDir','reverse')
