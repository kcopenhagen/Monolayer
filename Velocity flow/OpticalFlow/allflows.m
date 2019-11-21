function allflows(datapath)

fpathst = getfold(datapath);

imf = 1.6;
gf = 9; 
nf = 3;
opticFlow = opticalFlowLKDoG('GradientFilterSigma',gf,'ImageFilterSigma',imf,...
        'NumFrames',nf,'NoiseThreshold',0.000001);

for f = 1:numel(fpathst)
    fpath = fpathst{f};
    [~,~,~] = mkdir([fpath 'analysis/flows/Vx/']);
    [~,~,~] = mkdir([fpath 'analysis/flows/Vy/']);
    files = dir([fpath 'Laser/']);
    del = [];
    for i = 1:numel(files)
        if files(i).name(1) == "."
            del = [del; i];
        end
    end
    files(del) = [];
    MT = numel(files);
    
    for t = 1:MT
        l = preplaser(laserdata(fpath,t));
        flow = estimateFlow(opticFlow, l);

        data = flow.Vx;
            
        name = sprintf('%06d.bin',t-1);
        fID = fopen([fpath 'analysis/flows/Vx/' name],'w');
        fwrite(fID,data,'float');
        fclose(fID);
        
        data = flow.Vy;
        
        name = sprintf('%06d.bin',t-1);
        fID = fopen([fpath 'analysis/flows/Vy/' name],'w');
        fwrite(fID,data,'float');
        fclose(fID);
        
    end
    reset(opticFlow);
end

