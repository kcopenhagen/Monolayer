function h = xcorr_fft(a,b)
    e = fft2(a);
    f = fft2(b);
    
    g = conj(e).*f;
    h = fftshift(ifft2(g));
    
end