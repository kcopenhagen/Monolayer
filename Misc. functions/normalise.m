function n = normalise(im)
%Normalizes double array im to be between 0 and 1.
    im = im - min(im(:));
    n = im/max(im(:));
end