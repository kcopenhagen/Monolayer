fpath = uigetdir(datapath);
fpath = [fpath '/'];
files = dir([fpath 'Height/']);
dF = [files.isdir];
files = files(~dF);
N = numel(files);
del = [];

for t = 1:N
    if files(t).name(1) == '.'
        del = [del; t];
    end
end

files(del) = [];
N = numel(files);

%% Find best edge detection parameters:

[sfactors, clsizes, sffs, clfs, sfps, clps, pn] = edgevals(fpath);

%% Select optimal point from plot.
figure
scatter(sfps,clps,pn,'g','filled')
hold on
plot(sfactors,clsizes,'b.','MarkerSize',10)
plot(sffs,clfs,'r.','MarkerSize',10);
xlim([0.005 0.015]);
ylim([0 7]);

[sf,cl] = ginput(1);
cl = round(cl);
close 1


%% Display edges w/ current params. (Testing).
t = randi(N,1);
ed = layeredges(fpath,t,sf,cl);
l = laserdata(fpath,t);
overlaymaskimr(l,ed);

%% (A) Manually label steps between layers.
% Run either (A) or (B) not both.
alldifs = labellayers(fpath,sf,cl);

%% (A) Plot histogram and select cutoffs.
ed = -0.75:0.025:0.75;

figure
histogram([alldifs{1}],ed);
hold on
histogram([alldifs{2}],ed);
histogram([alldifs{3}],ed);

[b, ~] = ginput(2);
dh = (abs(b(1))+abs(b(2)))/2;
close 1
%% (B) Find step size between layers from automatic histogram.
dt = round(N/40);
dhs = finddh(fpath,sf,cl,dt);

%% (B) Do the histogramdango
clf
[hs, ed] = histcounts(dhs,100);
ed = ed - (ed(2)-ed(1))/2;
ed(1) = [];
hs(abs(ed)<0.09)=0;
histogram(dhs,100,'FaceColor',[0 0 0]);
set(gca,'FontSize',18);
xlabel('Height change (\mum)')
ylabel('Counts')
hold on
hf = fit(ed',hs','gauss2');
plot(hf);

[b, ~] = ginput(2);
close 1

dh = (abs(b(1))+abs(b(2)))/2

%% Test that it finds layers right.
t = randi(N,1);
findlayers(fpath,t,dh,sf,cl);
eds = layeredges(fpath,t,sf,cl);
l = laserdata(fpath,t);
h = heightdata(fpath,t);
hs = imgaussfilt(h,64);
h = h - hs;
lays = loaddata(fpath,t,'layers','int8');
overlaymaskimr(l,lays<1,lays==2);
overlaymaskimr(h,eds);


%% Save layers for all frames.
for t = 1:N
    t
    findlayers(fpath,t,dh,sf,cl);
end

%% Time median filter on the layers
medianlayers(fpath);

%% View and fix relavent layers by hand.

LayerVerification
