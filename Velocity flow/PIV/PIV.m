function [xs,ys,vx,vy] = PIV(fpath,t,dx)

    cent = round((dx+1)/2);
    l1 = laserdata(fpath,t);
    l2 = laserdata(fpath,t+1);
    l1 = imsharpen(l1,'Amount',3,'Radius',3);
    l1 = normalise(l1);
    l1s = imgaussfilt(l1,64);
    l1 = l1./l1s;

    l2 = imsharpen(l2,'Amount',3,'Radius',3);
    l2 = normalise(l2);
    l2s = imgaussfilt(l2,64);
    l2 = l2./l2s;

    xs = 1:dx/2:numel(l1(1,:))-dx-1;
    ys = 1:dx/2:numel(l1(:,1))-dx-1;
    
    drx = zeros(numel(ys),numel(xs));
    dry = zeros(numel(ys),numel(xs));
    
    fID = fopen([fpath 'times.txt']);
    times = fscanf(fID,'%f');
    fclose(fID);
    dt = (times(t+1)-times(t))/60;
    XYcal = getXYcal(fpath);
    
    for ix = 1:numel(xs)
        for jy = 1:numel(ys)
            i = xs(ix);
            j = ys(jy);
            
            a = l1(j:j+dx,i:i+dx);
            b = l2(j:j+dx,i:i+dx);

            h = xcorr_fft(a,b);
            p = xcorrpeak(h);

            drx(jy,ix) = p(1)-cent;
            dry(jy,ix) = p(2)-cent;
            
        end
    end
    
    vx = drx*XYcal/dt;
    vy = dry*XYcal/dt;
    xs = xs+dx/2;
    ys = ys+dx/2;
end