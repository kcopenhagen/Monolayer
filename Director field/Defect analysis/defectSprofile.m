function defectSprofile(datapath)
addpath('../../Director field');
%% Calculate all the things.

    imsize = 401;

    pavgs = zeros(imsize,imsize);
    pavgsn = zeros(imsize,imsize);
    navgs = zeros(imsize,imsize);
    navgsn = zeros(imsize,imsize);

    fpaths = getfold(datapath);

    for f = 1:numel(fpaths)
        fpath = fpaths{f};

        load([fpath 'adefs.mat'],'adefs');
        
        for i = 1:numel(adefs)

            St = findS(fpath,adefs(i).ts,2);
            St = padarray(St,[imsize,imsize],NaN,'both');

            if adefs(i).q > 0
                angle = -atan2d(adefs(i).d(2),adefs(i).d(1));
                S = St(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                    round(adefs(i).x):round(adefs(i).x+2*imsize));

                S = imrotate(S,-angle,'nearest','crop');
                S = S((imsize+1)/2+1:end-(imsize+1)/2,...
                    (imsize+1)/2+1:end-(imsize+1)/2);
                counts = ~isnan(S);
                S(isnan(S)) = 0;

                pavgs = pavgs+ S;
                pavgsn = pavgsn + counts;                


            elseif adefs(i).q<0
                %Rotate to d.
                angle = -atan2d(adefs(i).d(2),adefs(i).d(1));
                S = St(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                    round(adefs(i).x):round(adefs(i).x+2*imsize));
                S = imrotate(S,-angle,'nearest','crop');
                S = S((imsize+1)/2+1:end-(imsize+1)/2,...
                    (imsize+1)/2+1:end-(imsize+1)/2);
                counts = ~isnan(S);
                S(isnan(S)) = 0;

                navgs = navgs + S;
                navgsn = navgsn + counts;

                %Rotate to d + 120.
                angle = -atan2d(adefs(i).d(2),adefs(i).d(1))+120;
                S = St(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                    round(adefs(i).x):round(adefs(i).x+2*imsize));

                S = imrotate(S,-angle,'nearest','crop');
                S = S((imsize+1)/2+1:end-(imsize+1)/2,...
                    (imsize+1)/2+1:end-(imsize+1)/2);
                counts = ~isnan(S);
                S(isnan(S)) = 0;

                navgs = navgs + S;
                navgsn = navgsn + counts;


                %Rotate to d+240
                angle = -atan2d(adefs(i).d(2),adefs(i).d(1))+240;

                S = St(round(adefs(i).y):round(adefs(i).y+(2*imsize)),...
                    round(adefs(i).x):round(adefs(i).x+2*imsize));
                S = imrotate(S,-angle,'nearest','crop');
                S = S((imsize+1)/2+1:end-(imsize+1)/2,...
                    (imsize+1)/2+1:end-(imsize+1)/2);
                counts = ~isnan(S);
                S(isnan(S)) = 0;

                navgs = navgs + S;
                navgsn = navgsn + counts;

            end
            
        end
    end
    
pavgs = pavgs./pavgsn;
navgs = navgs./navgsn;

%% Plot positive ones
x = 1:imsize;
y = 1:imsize;
[xx,yy] = meshgrid(x,y);
rr = sqrt((xx-(imsize-1)/2).^2+(yy-(imsize-1)/2).^2);

im = real2rgb(pavgs,colorcet('L16'),[0 1]);
imr = im(:,:,1);
img = im(:,:,2);
imb = im(:,:,3);
imr(rr>(imsize-1)/2-2) = 0;
img(rr>(imsize-1)/2-2) = 0;
imb(rr>(imsize-1)/2-2) = 0;
imr(rr>(imsize-1)/2) = 1;
img(rr>(imsize-1)/2) = 1;
imb(rr>(imsize-1)/2) = 1;

im(:,:,1) = imr;
im(:,:,2) = img;
im(:,:,3) = imb;

show(im)

%% Plot negative ones
im = real2rgb(navgs,colorcet('L16'),[0 1]);

x = 1:imsize;
y = 1:imsize;
[xx,yy] = meshgrid(x,y);
rr = sqrt((xx-(imsize-1)/2).^2+(yy-(imsize-1)/2).^2);
imr = im(:,:,1);
img = im(:,:,2);
imb = im(:,:,3);
imr(rr>(imsize-1)/2-2) = 0;
img(rr>(imsize-1)/2-2) = 0;
imb(rr>(imsize-1)/2-2) = 0;
imr(rr>(imsize-1)/2) = 1;
img(rr>(imsize-1)/2) = 1;
imb(rr>(imsize-1)/2) = 1;

im(:,:,1) = imr;
im(:,:,2) = img;
im(:,:,3) = imb;

show(im)

%% Plot them averaged over angles.

x = 1:imsize;
y = 1:imsize;
[xx,yy] = meshgrid(x,y);
rr = sqrt((xx-(imsize-1)/2).^2+(yy-(imsize-1)/2).^2);

subs = round(rr)+1;
nsvsr = accumarray(subs(:),navgs(:),[numel(unique(subs)) 1],@mean);
psvsr = accumarray(subs(:),pavgs(:),[numel(unique(subs)) 1],@mean);
plot(unique(subs(:)-1)*0.133,nsvsr,'b')
hold on
plot(unique(subs(:)-1)*0.133,psvsr,'r')
xlim([0 5])
ylim([0 1])
set(gca,'FontSize',12)
xlabel('r (\mum)')
ylabel('S')
