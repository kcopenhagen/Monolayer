function br_ratio_distribution

area_sig = 4;
pt_sig = 2;

pt_kern = strel('disk',pt_sig).Neighborhood;
area_kern = strel('disk',area_sig).Neighborhood;
        
size_corr = numel(area_kern(:,1))-numel(pt_kern(:,1));
pt_kern = padarray(pt_kern,[size_corr/2,size_corr/2],0,'both');
        
kern = area_kern-pt_kern;
kern = kern/(sum(sum(kern)));
files = dir('/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Labeledflows/*mat');
pt_br_rats = [];
for f = 1:numel(files)
    load([files(f).folder '/' files(f).name ],'p0s','p1s','p2s','ids');
    temp = strsplit(files(f).name,'t');

    folder = temp{1};
    folder = folder(6:end);

    t = temp{2};
    t = strsplit(t,'.');
    t = str2num(t{1});

    fpath = [fileparts(files(f).folder) '/Data/' folder '/'];
    XYcal = getXYcal(fpath);

    l0 = laserdata(fpath,t-1);
    l1 = laserdata(fpath,t);
    l2 = laserdata(fpath,t+1);

    l0 = l0./imgaussfilt(l0,64);
    l1 = l1./imgaussfilt(l0,64);
    l2 = l2./imgaussfilt(l0,64);
    
%     l0 = imsharpen(l0,'Radius',3,'Amount',3);
%     l1 = imsharpen(l1,'Radius',3,'Amount',3);
%     l2 = imsharpen(l2,'Radius',3,'Amount',3);

    l0_a = conv2(l0,kern,'same');
    l1_a = conv2(l1,kern,'same');
    l2_a = conv2(l2,kern,'same');
            
    br_rat = l0./l0_a;

    xs = p0s(:,1);
    ys = p0s(:,2);
    sz = size(br_rat);
    pt_br_rats = [];
    inds = sub2ind(sz,round(ys),round(xs));
    pt_br_rats = [pt_br_rats; br_rat(inds)];

    br_rat = l1_c./l1_a;

    xs = p1s(:,1);
    ys = p1s(:,2);

    sz = size(br_rat);

    inds = sub2ind(sz,round(ys),round(xs));
    pt_br_rats = [pt_br_rats; br_rat(inds)];

    br_rat = l2_c./l2_a;

    xs = p2s(:,1);
    ys = p2s(:,2);

    sz = size(br_rat);

    inds = sub2ind(sz,round(ys),round(xs));
    pt_br_rats = [pt_br_rats; br_rat(inds)];
    
    histogram(pt_br_rats)
    hold on
end
