function mS = calcS(A)

    n = angularmean(2*A)/2;
    nx = cos(n);
    ny = sin(n);

    dx = cos(A);
    dy = sin(A);
    
    costheta = dx*nx+dy*ny;
    mS = (mean(2*costheta.^2-1));
end