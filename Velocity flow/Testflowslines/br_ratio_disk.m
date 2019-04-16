function br_ratio_disk
pt_sigs = 0:8;
area_sigs = 1:10;

mean_rats = NaN(numel(pt_sigs),numel(area_sigs));
std_rats = NaN(numel(pt_sigs),numel(area_sigs));
perc_gt_1 = NaN(numel(pt_sigs),numel(area_sigs));
for i = 1:numel(pt_sigs)
    i
    pt_sig = pt_sigs(i);
    pt_kern = strel('disk',pt_sig).Neighborhood;
    
    for j = i+1:numel(area_sigs)
        area_sig = area_sigs(j);
        area_kern = strel('disk',area_sig).Neighborhood;
        
        size_corr = numel(area_kern(:,1))-numel(pt_kern(:,1));
        pt_kern = padarray(pt_kern,[size_corr/2,size_corr/2],0,'both');
        
        kern = area_kern-pt_kern;
        kern = kern/(sum(sum(kern)));
        pt_kern = pt_kern/sum(sum(pt_kern));
        if pt_sig == 0
            pt_sig = 0.001;
        end
        pt_kern = fspecial('gaussian',numel(kern(:,1)),0.0001);
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
            
            l0 = imsharpen(l0,'Radius',3,'Amount',3);
            l1 = imsharpen(l1,'Radius',3,'Amount',3);
            l2 = imsharpen(l2,'Radius',3,'Amount',3);
            
            l0_c = conv2(l0,pt_kern,'same');
            l0_a = conv2(l0,kern,'same');

            l1_c = conv2(l1,pt_kern,'same');
            l1_a = conv2(l1,kern,'same');
            
            l2_c = conv2(l2,pt_kern,'same');
            l2_a = conv2(l2,kern,'same');
            
            br_rat = l0_c./l0_a;

            xs = p0s(:,1);
            ys = p0s(:,2);
            sz = size(br_rat);

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
        end

        mean_rats(i,j) = mean(pt_br_rats);
        std_rats(i,j) = std(pt_br_rats);
        perc_gt_1(i,j) = sum(pt_br_rats>1)/numel(pt_br_rats);
        
    end
end

figure
imagesc(mean_rats)
colorcet('R2')
colorbar
set(gca,'Ydir','normal')
set(gca,'FontSize',18);
set(gca,'xtick',[1 (numel(perc_gt_1(1,:))+1)/2 numel(perc_gt_1(1,:))])
set(gca,'ytick',[1 (numel(perc_gt_1(:,1))+1)/2 numel(perc_gt_1(:,1))])
set(gca,'xticklabels',[area_sigs(1) (area_sigs(1)+area_sigs(end))/2 area_sigs(end)])
set(gca,'yticklabels',[pt_sigs(1) (pt_sigs(1)+pt_sigs(end))/2 pt_sigs(end)])
ylabel('Inner radius');
xlabel('Outer radius');
figure
imagesc(std_rats)
colorcet('R2')
colorbar
set(gca,'Ydir','normal')
set(gca,'FontSize',18);
set(gca,'xtick',[1 (numel(perc_gt_1(1,:))+1)/2 numel(perc_gt_1(1,:))])
set(gca,'ytick',[1 (numel(perc_gt_1(:,1))+1)/2 numel(perc_gt_1(:,1))])
set(gca,'xticklabels',[area_sigs(1) (area_sigs(1)+area_sigs(end))/2 area_sigs(end)])
set(gca,'yticklabels',[pt_sigs(1) (pt_sigs(1)+pt_sigs(end))/2 pt_sigs(end)])
ylabel('Inner radius');
xlabel('Outer radius');
figure
imagesc(perc_gt_1)
colorcet('R2')
colorbar
set(gca,'Ydir','normal')
set(gca,'FontSize',18);
set(gca,'xtick',[1 (numel(perc_gt_1(1,:))+1)/2 numel(perc_gt_1(1,:))])
set(gca,'ytick',[1 (numel(perc_gt_1(:,1))+1)/2 numel(perc_gt_1(:,1))])
set(gca,'xticklabels',[area_sigs(1) (area_sigs(1)+area_sigs(end))/2 area_sigs(end)])
set(gca,'yticklabels',[pt_sigs(1) (pt_sigs(1)+pt_sigs(end))/2 pt_sigs(end)])
ylabel('Inner radius');
xlabel('Outer radius');