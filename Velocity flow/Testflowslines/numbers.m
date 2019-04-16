function numbers
%Prints out number of frames, cells and spline points labeled so far.
files = dir('/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate/Labeledflows/*mat');
nc = 0;
ns = 0;
for f = 1:numel(files)
    load([files(f).folder '/' files(f).name ],'ids');

    nc = nc + max(ids);
    ns = ns + numel(ids);
    
end

mess = sprintf(" Number of images labeled: %d \n Number of cells labeled: %d \n Total number of spline points: %d", numel(files), nc, ns);
disp(mess)