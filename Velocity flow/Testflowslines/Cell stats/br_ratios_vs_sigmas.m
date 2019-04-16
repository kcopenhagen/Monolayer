function br_ratios_vs_sigmas

pt_sigs = 0.0001:0.2:3;
area_sigs = 2:20:300;

mean_rats = zeros(numel(pt_sigs),numel(area_sigs));
std_rats = zeros(numel(pt_sigs),numel(area_sigs));
perc_gt_1 = zeros(numel(pt_sigs),numel(area_sigs));
for i = 1:numel(pt_sigs)
    pt_sig = pt_sigs(i);
    for j = 1:numel(area_sigs)
        area_sig = area_sigs(j);
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

            l0_c = imgaussfilt(l0,pt_sig);
            l0_a = imgaussfilt(l0,area_sig);

            l1_c = imgaussfilt(l1,pt_sig);
            l1_a = imgaussfilt(l1,area_sig);

            l2_c = imgaussfilt(l2,pt_sig);
            l2_a = imgaussfilt(l2,area_sig);

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
set(gca,'xtick',[1 8 15])
set(gca,'ytick',[1 8 15])
set(gca,'xticklabels',[2 142 282])
set(gca,'yticklabels',[0 1.4 2.8])
ylabel('Point \sigma');
xlabel('Surroundings \sigma');
figure
imagesc(std_rats)
colorcet('R2')
colorbar
set(gca,'Ydir','normal')
set(gca,'FontSize',18);
set(gca,'xtick',[1 8 15])
set(gca,'ytick',[1 8 15])
set(gca,'xticklabels',[2 142 282])
set(gca,'yticklabels',[0 1.4 2.8])
ylabel('Point \sigma');
xlabel('Surroundings \sigma');
figure
imagesc(perc_gt_1)
colorcet('R2')
colorbar
set(gca,'Ydir','normal')
set(gca,'FontSize',18);
set(gca,'xtick',[1 8 15])
set(gca,'ytick',[1 8 15])
set(gca,'xticklabels',[2 142 282])
set(gca,'yticklabels',[0 1.4 2.8])
ylabel('Point \sigma');
xlabel('Surroundings \sigma');