
folders = getfold(datapath);
np = 0;
nn = 0;
npf = 0;
nnf = 0;

for f = 1:numel(folders)
    load([fpath 'adefs.mat'],'adefs');
    pdefs = adefs([adefs.q]>0);
    ndefs = adefs([adefs.q]<0);
    np = np + numel(unique([pdefs.id]));
    nn = nn + numel(unique([ndefs.id]));
    npf = npf+numel(pdefs);
    nnf = nnf+numel(ndefs);
end
disp(['Positive defects: ' num2str(np)]);
disp(['Negative defects: ' num2str(nn)]);
disp(['Positive defect frames: ' num2str(npf)]);
disp(['Negative defect frames: ' num2str(nnf)]);
