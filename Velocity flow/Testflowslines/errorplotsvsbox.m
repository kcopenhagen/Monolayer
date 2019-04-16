meandthetas = [];
meanmagrats = [];
eds = 0:pi/36:pi;
eds2 = -2:0.5:20;
f1 = figure;
f2 = figure;
for dx = 4:2:46
    dx
    [dtheta, magrat] = veri_PIV(dx);
    figure(f1)
    histogram(dtheta,eds)
    hold on
    figure(f2)
    histogram(magrat,eds2)
    hold on
    
    meandthetas = [meandthetas; nanmean(dtheta)];
    meanmagrats = [meanmagrats; nanmean(abs(magrat))];
    
end
figure(f1)
set(gca,'FontSize',18);
xlabel('\Delta\theta (radians)');
ylabel('Counts');
figure(f2)
set(gca,'FontSize',18);
xlabel('\Deltamagnitude (\mu/min)');
ylabel('Counts');
figure
plot(4:2:46,meandthetas,'r','LineWidth',2);
set(gca,'FontSize',18);
xlabel('Box size');
ylabel('Mean \Delta\theta');
figure
plot(4:2:46,meanmagrats,'r','LineWidth',2);
set(gca,'FontSize',18);
xlabel('Box size');
ylabel('Mean \Deltamagnitude');