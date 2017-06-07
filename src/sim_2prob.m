% sim_2prob.m


report_this_filefun(mfilename('fullpath'));


% needed variables
% BigCatalog        big catalog from which to take the eqs randomly, produced by translating
%                   consists of 100000 eqs
% ni                number of earthquakes in a bin, i.e. sample size
% NuBins            number of bins
% BinLength         1/length(xt), length of shortest possible interval
% iwl               length of interval in times shortest
% NuRep             number of repetitions

delta=iwl/NuBins;

for nto=1:NuRep
    disp(nto);

    which=ceil(100000*(rand(ni)));
    for i=1:ni
        rancata(i)=BigCatalog(which(i));
    end
    clear i which;
    rancata=ceil(rancata*NuBins);

    for i=1:NuBins
        l=sum(rancata==i); Bins(i,1)=sum(l); clear l;
    end
    clear rancata i;

    FirstBin=ceil(rand(1)*(NuBins-iwl+1));


    zin=Bins(FirstBin:FirstBin+iwl-1); zout=[Bins(1:FirstBin-1,1); Bins(FirstBin+iwl:NuBins,1)];
    ToBeFitted(nto,1)=nto;
    % calculating beta
    ToBeFitted(nto,2)=(sum(zin)-ni*delta)/(sqrt(ni*delta*(1-delta)));
    % calculating z
    ToBeFitted(nto,3)=(mean(zout)-mean(zin))/(sqrt(var(zin)/sum(zin)+var(zout)/sum(zout)));
    clear Bins FirstBin zin zout;
end
clear BigCatalog nto delta;

[meanval, std] =normfit(ToBeFitted(:,2)); IsFitted(1,1)=meanval; IsFitted(1,2)=std;
[meanval, std] =normfit(ToBeFitted(:,3)); IsFitted(2,1)=meanval; IsFitted(2,2)=std;
clear meanval std;
clear ToBeFitted;

switch value2trans
    case 'beta'
        Pbeta = normcdf(BetaValues,IsFitted(1,1),IsFitted(1,2));
        l = Pbeta == 0; Pbeta(l) = nan;
    case 'z'
        Pbeta = normcdf(BetaValues,IsFitted(2,1),IsFitted(2,2));
        l = Pbeta == 0; Pbeta(l) = nan;
end

% plot the resuts
figure
pq = -log10(1-Pbeta); l = isinf(pq);pq(l) = 18 ;
pl1 = plot(xt,pq,'color',[0.0 0.5 0.9]);
hold on
l = pq < 1.3; pq(l) = nan;
pl3 = plot(xt,pq,'b','Linewidth',2);

pq = -log10(Pbeta);l = isinf(pq);pq(l) = 18 ;
pl2 = plot(xt,pq,'color',[0.8 0.6 0.8]);
l = pq < 1.3; pq(l) = nan;
pl4 = plot(xt,pq,'r','Linewidth',2);

maxd = [get(pl1,'Ydata') get(pl2,'ydata') ]; maxd(isinf(maxd)) = []; maxd = max(maxd);
if maxd < 5 ; maxd = 5; end
if isnan(maxd) == 1 ; maxd = 10; end

legend([pl3 pl4],'Rate increases','Rate decreases');
set(gca,'Ylim',[0 maxd+1])
set(gca,'YTick',[1.3 2 3 4 5])
set(gca,'YTickLabel',[ '    5%' ; '    1%' ;  '  0.1%' ;  ' 0.01%' ; '0.001%'])
set(gca,'TickDir','out','Ticklength',[0.02 0.02],'pos',[0.2 0.2 0.7 0.7]);
xlabel('Time [years]')
ylabel('Significance level');
set(gcf,'color','w')
grid

uicontrol('Units','normal',...
    'Position',[.8 .0 .1 .05],'String','Explain ... ',...
     'Callback','showweb(''explproba'');')

delete(probut)

