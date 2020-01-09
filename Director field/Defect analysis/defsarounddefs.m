function defsarounddefs

%%Plot defects around other defects.

figure('Units','pixels','Position',[300 300 400 400])
axes('Position',[0 0 1 1])

theta = -pi:pi/6:pi;
phi = 2/3*(theta+pi)-pi/3;

quiver(0,0,0.2,0,'r','AutoScale','off','ShowArrowHead','off','LineWidth',2)
hold on
plot(0,0,'r.','MarkerSize',30);
plot(cos(theta),sin(theta),'b.','MarkerSize',30)
quiver(cos(theta),sin(theta),0.2*cos(phi),0.2*sin(phi),'b','AutoScale','off','ShowArrowHead','off','LineWidth',2);
quiver(cos(theta),sin(theta),0.2*cos(phi+2*pi/3),0.2*sin(phi+2*pi/3),'b','AutoScale','off','ShowArrowHead','off','LineWidth',2);
quiver(cos(theta),sin(theta),0.2*cos(phi+4*pi/3),0.2*sin(phi+4*pi/3),'b','AutoScale','off','ShowArrowHead','off','LineWidth',2);

xlim([-1.5 1.5])
ylim([-1.5 1.5])

axis off

%%

figure('Units','pixels','Position',[300 300 400 400])
axes('Position',[0 0 1 1])

theta = -pi:pi/6:pi;
phi = -2*(theta)+pi;

quiver(0,0,0.2,0,'b','AutoScale','off','ShowArrowHead','off','LineWidth',2)
hold on
quiver(0,0,0.2*cos(2*pi/3),0.2*sin(2*pi/3),'b','AutoScale','off','ShowArrowHead','off','LineWidth',2)
quiver(0,0,0.2*cos(4*pi/3),0.2*sin(4*pi/3),'b','AutoScale','off','ShowArrowHead','off','LineWidth',2)
plot(0,0,'b.','MarkerSize',30);
plot(cos(theta),sin(theta),'r.','MarkerSize',30)
quiver(cos(theta),sin(theta),0.2*cos(phi),0.2*sin(phi),'r','AutoScale','off','ShowArrowHead','off','LineWidth',2);

xlim([-1.5 1.5])
ylim([-1.5 1.5])

axis off
