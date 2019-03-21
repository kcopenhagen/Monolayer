function flow = calctestflow(fpath,tt,nf,gf,imf)

    files = dir([fpath '/Laser/']);
    dirFlags = [files.isdir];
    files(dirFlags) = [];
    N = numel(files);

%     nf = 7;
%     gf = 13;
%     imf = 1;

    opticFlow = opticalFlowLKDoG('GradientFilterSigma',gf,'ImageFilterSigma',imf,'NumFrames',nf,'NoiseThreshold',0.0001);

    for t = tt-(nf+1)/2:tt+(nf+1)/2
        l = laserdata(fpath,t);
%         ls = imsharpen(l,'Radius',3,'Amount',3);
%         lsm = imgaussfilt(l,64);
% 
%         l = ls./lsm;
        l = normalise(l);

        flow = estimateFlow(opticFlow, l);
    end
end