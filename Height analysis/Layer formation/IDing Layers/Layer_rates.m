function Layer_rates(datapath)
%% Find the rate of layer formation at different heights.

fpaths = getfold(datapath);
r = round(2.5/0.133);
se = strel('disk',r,8);

for f = 1:numel(fpaths)
    fpath = fpaths{f};
    ts = getts(fpath);
    exptA1 = 0;
    adefs = load([fpath 'adefs.mat']);
    for t = 1:numel(ts)
        cdefs = adefs([adefs.ts]==t);
        cpdefs = cdefs([cdefs.q]>0);
        cndefs = cdefs([cdefs.q]<0);
        
        layers = loaddata(fpath,t,'manuallayers','int8');
        layers = round(imgaussfilt(layers,3));
        zero_im = zeros(size(layers));
        cpdef_inds = sub2ind(size(zero_im),[cpdefs.y],[cpdefs.x]);
        pdef_areas = zero_im;
        pdef_areas(cpdef_inds) = 1;
        pdef_areas = imdilate(pdef_areas,se);
        cndef_inds = sub2ind(size(zero_im),[cndefs.y],[cndefs.x]);
        ndef_areas = zero_im;
        ndef_areas(cndef_inds) = 1;
        ndef_areas = imdilate(ndef_areas,se);
        
        A1 = 0.133^2*sum(layers(:)==1);
        exptA1 = exptA1 + A1;
    end
    expt = (ts(end)-ts(1))/60;
    
end