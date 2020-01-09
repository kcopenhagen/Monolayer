%%

x = (1:numel(pavgdx(1,:)))-(numel(pavgdx(1,:))-1)/2;
y = (1:numel(pavgdx(:,1)))-(numel(pavgdx(:,1))-1)/2;

[xx, yy] = meshgrid(x,y);

theta = atan2(yy,xx);

pphi = theta/2;

actualpphi = atan2(pavgdy,pavgdx);

angdif = actualpphi - pphi;
angdif(angdif>pi/2) = angdif(angdif>pi/2)-pi;
angdif(angdif<-pi/2) = angdif(angdif<-pi/2)+pi;
show(angdif)
caxis([-0.5 0.5])
hold on
rs = sqrt(xx.^2+yy.^2);
pts = abs(rs-100)<1;

plot(xx(pts)+200,yy(pts)+200,'r.')

figure
plot(theta(pts),pphi(pts),'k.');
hold on
plot(theta(pts),actualpphi(pts),'r.');
xlabel('\Theta');
ylabel('\Phi');
set(gca,'FontSize',12);

figure
subs = round(rs);
rdep = accumarray(subs(:)+1,angdif(:),[],@mean);
plot(unique(subs)*0.133,rdep,'r','LineWidth',2)
xlim(0.133*[2 200])
ylim([-0.1 0.01])
set(gca,'FontSize',12);
xlabel('r({\mu}m)')

figure
subs = round(((theta-min(theta(:)))*20+1));
thdep = accumarray(subs(rs<200),angdif(rs<200),[],@mean);
plot(unique(subs)/20-pi,thdep,'b','LineWidth',2)
set(gca,'FontSize',12);
xlabel('\phi')
ylim([-0.35 0.15])
%%

x = (1:numel(pavgdx(1,:)))-(numel(pavgdx(1,:))-1)/2;
y = (1:numel(pavgdx(:,1)))-(numel(pavgdx(:,1))-1)/2;

[xx, yy] = meshgrid(x,y);

theta = atan2(yy,xx);

pphi = -theta/2;

actualpphi = atan2(navgdy,navgdx);

angdif = actualpphi - pphi;
angdif(angdif>pi/2) = angdif(angdif>pi/2)-pi;
angdif(angdif<-pi/2) = angdif(angdif<-pi/2)+pi;
show(angdif)
caxis([-0.5 0.5])
hold on
rs = sqrt(xx.^2+yy.^2);
pts = abs(rs-100)<1;

plot(xx(pts)+200,yy(pts)+200,'r.')

figure
plot(theta(pts),pphi(pts),'k.');
hold on
plot(theta(pts),actualpphi(pts),'r.');
xlabel('\Theta');
ylabel('\Phi');
set(gca,'FontSize',12);

figure
subs = round(rs);
rdep = accumarray(subs(:)+1,angdif(:),[],@mean);
plot(unique(subs)*0.133,rdep,'r','LineWidth',2)
xlim(0.133*[2 200])
ylim([-0.1 0.01])
set(gca,'FontSize',12);
xlabel('r({\mu}m)')

figure
subs = round(((theta-min(theta(:)))*20+1));
thdep = accumarray(subs(rs<200),angdif(rs<200),[],@mean);
plot(unique(subs)/20-pi,thdep,'b','LineWidth',2)
set(gca,'FontSize',12);
xlabel('\phi')
ylim([-0.35 0.15])