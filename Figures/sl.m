function sld = sl(vx, vy, u0, L)

    hmax = 10;
    ht = 1;
    TOL = 1;
    sz = size(vx);
    
    function f = ff(u)
        
        ux = u(1);
        uy = u(2);
        
        if (ux<1 || uy<1 || ux>sz(2)-1 || uy>sz(1)-1 || isnan(ux) || isnan(uy))
            f = [NaN NaN];
            return
        end
        if (rem(ux,1)==0 && rem(uy,1)==0)
            vxu = vx(uy,ux);
            vyu = vy(uy,ux);
        else
            if (rem(ux,1)==0)
                ux = ux+0.00001;
            end
            if (rem(uy,1)==0)
                uy = uy+0.00001;
            end
            ux1 = floor(u(1));
            ux2 = ceil(u(1));
            uy1 = floor(u(2));
            uy2 = ceil(u(2));
            
            vx11 = vx(uy1,ux1);
            vx12 = vx(uy1,ux2);
            vx21 = vx(uy2,ux1);
            vx22 = vx(uy2,ux2);

            vy11 = vy(uy1,ux1);
            vy12 = vy(uy1,ux2);
            vy21 = vy(uy2,ux1);
            vy22 = vy(uy2,ux2);
            
            if vx11*vx12+vy11*vy12<0
                vx12 = -vx12;
                vy12 = -vy12;
            end
            if vx12*vx22+vy12*vy22<0
                vx22 = -vx22;
                vy22 = -vy22;
            end
            if vx22*vx21+vy22*vy21<0
                vx21 = -vx21;
                vy21 = -vy21;
            end
            
            vxu = 1/((ux2-ux1)*(uy2-uy1))*[(ux2-ux) (ux-ux1)]*[vx11 vx12; vx21 vx22]...
                *[uy2-uy; uy-uy1];

            vyu = 1/((ux2-ux1)*(uy2-uy1))*[(ux2-ux) (ux-ux1)]*[vy11 vy12; vy21 vy22]...
                *[uy2-uy; uy-uy1];
        end

        vmag = sqrt(vxu^2+vyu^2);
        f = [vxu/vmag, vyu/vmag];

    end

    function [uh, hn, slfn] = sigma(u,h,slf)
        
        ffuk1 = slf;
        k1 = h*ffuk1;
        
        ffuk2 = ff(u+1/2*k1);
        if sum(ffuk1.*ffuk2)<0
            ffuk2 = -ffuk2;
        end
        k2 = h*ffuk2;
        
        ffuk3 = ff(u+1/2*k2);
        if sum(ffuk2.*ffuk3)<0
            ffuk3 = -ffuk3;
        end
        k3 = h*ffuk3;
        
        ffuk4 = ff(u+k3);
        if sum(ffuk3.*ffuk4)<0
            ffuk4 = -ffuk4;
        end
        k4 = h*ffuk4;
        
        uh = u + k1/6 + k2/3 + k3/3 + k4/6;
        ffuh = ff(uh);
        if sum(ffuh.*ffuk1)<0
            ffuh = -ffuh;
        end
        D = 1/6*(k4 - h*ffuh);
        
        
        while sqrt(D(1)^2+D(2)^2)>TOL && h>0.1 && ~isnan(uh(1)) && ~isnan(uh(2))
            h = h*(0.9*TOL/sqrt(D(1)^2+D(2)^2))^(1/5);
            ffuk1 = slf;
            k1 = h*ffuk1;

            ffuk2 = ff(u+1/2*k1);
            if sum(ffuk1.*ffuk2)<0
                ffuk2 = -ffuk2;
            end
            k2 = h*ffuk2;

            ffuk3 = ff(u+1/2*k2);
            if sum(ffuk2.*ffuk3)<0
                ffuk3 = -ffuk3;
            end
            k3 = h*ffuk3;

            ffuk4 = ff(u+k3);
            if sum(ffuk3.*ffuk4)<0
                ffuk4 = -ffuk4;
            end
            k4 = h*ffuk4;

            uh = u + k1/6 + k2/3 + k3/3 + k4/6;
            ffuh = ff(uh);
            if sum(ffuh.*ffuk1)<0
                ffuh = -ffuh;
            end
            D = 1/6*(k4 - h*ffuh);
        end
        
        if (abs(h)<0.1 || uh(1)<=0 || uh(2)<=0 || uh(1)>sz(2) || uh(2)>sz(1))
            uh = [NaN; NaN];
        end
        slfn = ffuh;
        hn = min(abs(h),hmax)*h/abs(h);
    end

    function [sldt, u0ns] = pf(u0s, hc, xn, xnp1)
        
        delt = ht/abs(hc);
        u0t = u0s/abs(hc);
        u = u0t;
        p0 = xn;
        p1 = xnp1;
        pp0 = hc*ff(xn);
        pp1 = hc*ff(xnp1);
        a = 2*p0-2*p1+pp0+pp1;
        b = -3*p0+3*p1-2*pp0-pp1;
        c = pp0;
        d = p0;
        pu = a*u^3+b*u^2+c*u+d;

        d1pu = 3*a*delt*u^2+(3*a*delt^2+2*b*delt)*u+a*delt^3+b*delt^2+c*delt;
        d2pu = 6*a*delt^2*u+6*a*delt^3+2*b*delt^2;
        d3pu = 6*a*delt^3;

        puk = pu;

        sldt = NaN(1+floor((1-u0t)/delt),2);
        sldt(1,:) = puk;
        for i = 2:numel(sldt(:,1))
            puk = puk + d1pu;
            d1pu = d1pu + d2pu;
            d2pu = d2pu + d3pu;
            sldt(i,:) = puk;

        end

        u0ns = (1-(u0t+delt*(numel(sldt(:,1))-1)))*abs(hc);
    end

    slr = NaN(L,2);
    sld = NaN(L,2);
    slf = NaN(L,2);
    slr(1,:) = u0;
    sld(1,:) = u0;
    slf(1,:) = ff(u0);
    it = 2;
    jt = 2;
    u0s = ht;
    h = hmax;
    while (it<=L)
        
        [uh, hn, slfn] = sigma(slr(jt-1,:),h,slf(jt-1,:));
        
        if isnan(uh(1))
            break;
        end
        
        slr(jt,:) = uh;
        slf(jt,:) = slfn;
        
        if (hn<ht)
            break;
        end
        [sldt, u0s] = pf((ht-u0s), hn, slr(jt-1,:), slr(jt,:));
        
        jt = jt+1;
        if (isnan(sldt(1)))
            break
        end
        h = hn;
        endt = it+numel(sldt(:,1))-1;
        if (endt>L)
            endt=L;
        end
        
        sld(it:endt,:) = sldt(1:endt-it+1,:);
        it = endt+1;
    end

end

