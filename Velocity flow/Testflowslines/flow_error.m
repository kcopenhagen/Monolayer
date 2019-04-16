function flow_error(lv, cv) %Labeled velocities, calculated velocities.

lvmag = sqrt(lv(:,1).^2+lv(:,2).^2);
cvmag = sqrt(cv(:,1).^2+cv(:,2).^2);
theta = acos((lv(:,1).*cv(:,1)+lv(:,2).*cv(:,2))./(lvmag.*cvmag));

magrat = cvmag./lvmag;

vcs = cv*mean(magrat);

histogram(theta,20)
