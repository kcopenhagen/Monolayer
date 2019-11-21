%% Figure out timing

fpaths = getfold(datapath);

intime = 60*[3; 3; 4; 4.5; 2; 2; 2; 2];
outtime = 60*[0.5; 3; 0.5; 0.25; 0.5; 1; 2; 4];
cols = ['r'; 'r'; 'g'; 'b'; 'k'; 'k'; 'k'; 'k'];
figure
hold(gca,'on');
for f = 1:numel(fpaths)
    fpath = fpaths{f};
    ts = getts(fpath)/60;
    plot([0 intime(f)],[f f],cols(f),'LineStyle','--');
    plot([intime(f) outtime(f)+intime(f)], [f f], cols(f))    
    plot([outtime(f)+intime(f) max(ts)-min(ts)+outtime(f)+intime(f)], [f f], cols(f),'LineWidth',2);
    
end
set(gca,'ydir','reverse');
ylim([0 9])