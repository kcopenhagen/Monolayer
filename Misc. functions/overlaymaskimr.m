function overlaymaskimr(im,maskg,maskr)
    if nargin<3
        maskr = zeros(size(maskg));
    end
    rgbim = zeros(numel(im(:,1)),numel(im(1,:)),3);
    rgbim(:,:,1) = (im-1.6*min(min(im)))/(max(max(im-1.6*min(min(im)))));
    rgbim(:,:,2) = (im-1.6*min(min(im)))/(max(max(im-1.6*min(min(im)))));
    rgbim(:,:,3) = (im-1.6*min(min(im)))/(max(max(im-1.6*min(min(im)))));
    rim = rgbim(:,:,1);
    rim(maskr==1) = rim(maskr==1)+0.3;
    gim = rgbim(:,:,2);
    gim(maskg==1) = gim(maskg==1)+0.3;
    rgbim(:,:,1) = rim;
    rgbim(:,:,2) = gim;
    figure('Position',[200 0 1024 768],'PaperUnits','points','PaperSize',[1024 768])
    subplot('Position',[0 0 1 1])
    imshow(rgbim);
    axis off
end