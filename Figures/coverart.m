%%
cmap = colorcet('R2');

him = real2rgb(hproc',cmap,[-0.2 0.2]);
I = imshow(him);
set(I,'AlphaData',LICnorm');
set(gcf,'Color','k')
%%
LIC2norm = normalise(LIC2im);

vim = real2rgb(vmag',colorcet('R2'));
I = imshow(vim);
set(I,'AlphaData',LICnorm');
set(gcf,'Color','k')

%%

dfim = real2rgb(dfield',orientcmap);
I = imshow(dfim);
set(I, 'AlphaData',LIC2norm');
set(gcf,'Color','k')

%%
dfield2 = dfield(1:724,:);
dfim = real2rgb(dfield2',orientcmap);
dfim = dfim;
dfim(dfim>1) = 1;
fig = figure('visible','off','InvertHardCopy', 'off','Units','pixels',...
    'Position',[0 0 724 1024],'Color','k','PaperUnits','centimeters',...
    'PaperPosition',[0 0 21 29.7],'PaperSize',[21 29.7]);
ax = axes('Units','pixels','Position',[0 0 724 1024],'Color','k');
alphas = LICim';
alphas = alphas(:,1:724);
I = imshow(dfim,'Parent',ax);

set(I,'AlphaData',alphas);
%saveas(fig,'/Users/kcopenhagen/Google Drive/Myxobacteria/Paper submissions/Layer formation/coverart2.pdf');
print(fig,'-dtiff','/Users/kcopenhagen/Google Drive/Myxobacteria/Paper submissions/Layer formation/coverart1.tiff','-r300')