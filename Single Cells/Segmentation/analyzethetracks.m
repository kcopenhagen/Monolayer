
%% Speed histogram
speeds = [];
for i = 1:numel(acells)
    v = acells(i).v;
    if ~isempty(v)
        speed = sqrt(v(1)^2+v(2)^2);
        speeds = [speeds; speed];
    end
end

histogram(speeds,'FaceColor','k')
set(gca,'FontSize',12)
xlabel('Speed (\mum/min)')
ylabel('Count')

%% Live cell speed histogram
ids = unique([acells.id]);
speeds = [];

for i = 1:numel(ids)
    id = ids(i);
    ccells = acells([acells.id]==id);
    uzeit = false;
    speedst = [];
    for j = 1:numel(ccells)
        speed = sqrt(ccells(j).v(1)^2+ccells(j).v(2)^2);
        speedst = [speedst; speed];
        if speed>1
            uzeit = true;
        end
    end
    if uzeit
        
        speeds = [speeds; speedst];
    end
end
i = 1;


eds = 0:0.1:10;
pvs = histcounts(speeds,eds,'Normalization','pdf');

plot(eds(2:end)-eds(1)/2,pvs,'k','LineWidth',2);
hold on
set(gca,'FontSize',18);
xlabel('Speed (\mum /min)');
ylabel('PDF');

%% Autocorrelation of velocities to find the reversals

ids = unique([acells.id]);

while i < numel(ids)
    
    i = i+1;
    %%
    id = ids(i);
    ccells = acells([acells.id] == id);
    mask = zeros(size(lBW));
    vs = [ccells.v];
    vxs = vs(1:2:end-1);
    vys = vs(2:2:end);
    spds = sqrt(vxs.^2+vys.^2);
    %vxs = vxs./spds;
    %vys = vys./spds;
    cx = (vxs'*vxs);
    cy = (vys'*vys);
    acorr = cx + cy;
    fig = figure('Units','pixels','Position',[410 10 400 400]);
    ax = axes(fig,'Position',[0 0 1 1]);
    C = contour(ax,sign(acorr),[-Inf 0 Inf]);
    [a,b] = histcounts(C(1,:),'BinMethod','integer');
    rts = b(a>numel(ccells)/2);
    orts = rts;
    spsq = diag(acorr);
    spsq = [0; spsq; 0];
    [~,lcs] = findpeaks(spsq,'MinPeakHeight',0.25);
    
    lcs = lcs-1;
    lcs(lcs<1) = 1;
    if (~isempty(lcs))
        rts(rts<lcs(1)) = [];
        rts(rts>lcs(end)) = [];
        for l = 1:numel(lcs)-1
            crs = find((rts>lcs(l)).*(rts<lcs(l+1)));

            if acorr(lcs(l),lcs(l+1))<0
                r1 = ceil(rts(crs(1))-1);
                r1(r1<1) = 1;
                r2 = floor(rts(crs(end))+1);
                md = 0;
                for k = 1:numel(crs)
                    ac11 = acorr(r1:rts(crs(k)),r1:rts(crs(k)));
                    ac22 = acorr(rts(crs(k)):r2,rts(crs(k)):r2);
                    ac12 = acorr(r1:rts(crs(k)),rts(crs(k)):r2);
                    ac21 = acorr(rts(crs(k)):r2,r1:rts(crs(k)));
                    
                    tmd = mean([ac11(:); ac22(:)])-mean([ac12(:); ac21(:)]);
                    if abs(tmd)>md
                        md = abs(tmd);
                        mk = crs(k);
                    end
                end

                crs(crs==mk) = [];
            end
            rts(crs) = [];

        end

    else
        rts = [];
    end
    revs = zeros(size(ccells));
    revs(floor(rts)) = 1;
    for j = 1:numel(ccells)
        ccells(j).rev = revs(j);
    end
    acells([acells.id]==ids(i)) = ccells;
    
    figure('Units','pixels','Position',[10 10 400 400]);
    imagesc(cx+cy,[-1 1]);
    colormap gray
    hold on
    
    plot(C(1,:),C(2,:),'r.');
    plot(rts,rts,'y+');
    plot(orts,orts,'c.');

    pause(1);
    close all
    
end

%% Video of 1 cells mask

ccells = acells([acells.id] == ids(i));
clear F2
F2(numel(ccells)) = struct('cdata',[],'colormap',[]);

for t = 1:numel(ccells)
    
    mask = zeros(size(lBW));
    zmask = zeros(size(lBW));
    mask(ccells(t).PixelIdxList) = 1;
    if ccells(t).rev == 0
        mask2 = cat(3,zmask,mask);
        mask = cat(3,mask2,zmask);
    else
        mask2 = cat(3,mask,zmask);
        mask = cat(3,mask2,zmask);
    end
    F2(t) = im2frame(mask);
end

playmovie(F2)

%% Put the video into a file.

v = VideoWriter('allvid.avi');
v.FrameRate = 30;
v.Quality = 15;
open(v);

for t = 1:numel(F)/2
    writeVideo(v,F(t));
end
close(v);

%% Actual reversal period calc.

ids = unique([acells.id]);
revTs = [];
for i = 1:numel(ids)
    id = ids(i);
    ccells = acells([acells.id] == id);
    ts = [ccells.ts];
    revs = [ccells.rev];
    revts = ts(revs==1);
    if numel(revts)>1
        for t = 1:numel(revts)-1
            revTs = [revTs; revts(t+1)-revts(t)];
        end
    end
end

histogram(revTs/60,'FaceColor','y');
set(gca,'FontSize',12);
xlabel('Reversal period')
ylabel('Count')


%% Alternative reversal period calculation.

ids = unique([acells.id]);
trtime = 0;
mtrtime = 0;
nrevs = sum([acells.rev]);

for i = 1:numel(ids)
    ccells = acells([acells.id] == ids(i));
    
    trtime = trtime + (ccells(end).ts-ccells(1).ts);
    for t = 2:numel(ccells)
        if ccells(t).v(1)^2+ccells(t).v(2)^2>1
            mtrtime = mtrtime+(ccells(t).ts-ccells(t-1).ts);
        end
        
    end
    
    
end
mvrt = (mtrtime/nrevs)/60
rt = (trtime/nrevs)/60

    %% Find drift
    fpath = fpaths{2};
    fcells = acells(4658:15093);

    l = laserdata(fpath,1);
    l = l./imgaussfilt(l,64);
    l = 2*normalise(l)-1;
    dr = [0 0];
    for t = 2:max([fcells.t])
        lp = l;
        l = laserdata(fpath,t);
        l = l./imgaussfilt(l,64);
        l = 2*normalise(l)-1;
        h = xcorr_fft(l,lp);
        p = xcorrpeak(h);
        center = size(lBW')/2+1;
        
        dr = [dr; center-p];
    end
    "Drift calculated"

    
%% Watch the cells wiggle around colored by speed.

fcells = acells;
fpath = fpaths{2};
ids = unique([fcells.id]);
colors = zeros(numel(ids),3);
for j = 1:numel(ids)
    colors(j,:) = rand(1,3);
end

sz = size(lBW);
clear F
F(max([fcells.t])) = struct('cdata',[],'colormap',[]);
fig = figure('Units','pixels','Position',[0 0 1024/2 768/2]);
ax = axes(fig,'Position',[0 0 1 1]);
axis off
xlims = [-100 1124];
ylims = [-100 868];

for t = 1:max([fcells.t])
    maskr = ones(size(lBW));
    maskg = ones(size(lBW));
    maskb = ones(size(lBW));

    ccells = fcells([fcells.t] == t);
    for i = 1:numel(ccells)
        if ~isempty(ccells(i).v)
            spd = sqrt(ccells(i).v(1)^2+ccells(i).v(2)^2);
            clims = [0 5];
            cr = (clims(2) - spd)/((clims(2)-clims(1))/2);
            cr(cr>1) = 1;
            cg = spd/((clims(2)-clims(1))/2);
            cg(cg>1) = 1;

            maskr([ccells(i).PixelIdxList]) = cr;
            maskg([ccells(i).PixelIdxList]) = cg;
            maskb([ccells(i).PixelIdxList]) = 0;

        end

    end

    imshow(mask);
    l = laserdata(fpath,t);
    l = l./imgaussfilt(l,64);
    l = normalise(l);

    maskr = l.*maskr;
    maskg = l.*maskg;
    maskb = l.*maskb;

    mask = cat(3,maskr,maskg);
    mask = cat(3,mask,maskb);
    clf

    imshow(mask)

    xlims = xlims+round(dr(t,1));
    ylims = ylims+round(dr(t,2));
    xlim(xlims);
    ylim(ylims);
    F(t) = getframe;
end

playmovie(F)


"Movie generated"

%% Peclet-1 number

lcell = 2.5;
v0 = mean(speeds);
Dr = 0.127;
T = mean(revTs/60);
frev = 1/T;

sigv02 = var(speeds)/sqrt(numel(speeds));
Tvar = var(revTs/60)/sqrt(numel(revTs));
sigfrev2 = frev^2*(Tvar/T^2);

A = lcell/v0;
sigA2 = A^2*(sigv02/v0^2);
B = Dr + 2*frev;
sigB2 = 2^2*sigfrev2;

Pe = A*B
sigPe = Pe^2*(sigA2/A^2 + sigB2/B^2)
