function mang = angularmean(thetas)
    dx = cos(thetas);
    dy = sin(thetas);
    
    mdx = mean(dx);
    mdy = mean(dy);
    
    mang = atan2(mdy,mdx);
end