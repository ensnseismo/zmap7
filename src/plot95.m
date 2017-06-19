% This program plots a polar projection od the
% best fitting stress-tensor and the 95% confidence limits
%
% stefan Wiemer 05/96

report_this_filefun(mfilename('fullpath'));

figure_w_normalized_uicontrolunits( ...
    'Name','Polar projection of stress tensor inversion result ',...
    'NumberTitle','off', ...
    'NextPlot','add', ...
    'Visible','on', ...
    'Position',[ fipo(3)-600 fipo(4)-500 winx winx]);

global c i newgri ste s te te1  te2 te3
%hodis = [hodi '/stinvers'];
%do = ['load ' hodis '/out95'];
%eval(do)
load out95
% find the 95% confidence region

if exist('tmpi')==0 | exist('tmp.')==2
    def = {'30'};
    ni2 = inputdlg('How many events were used in the inversion?','Input',1,def);
    l = ni2{1};
    n = str2double(l);
else
    n = length(tmpi(:,1));
end
f2 = out95;
fit = min(out95(:,9));
pai = atan(1.0)*4;
k = 4;
conf = 1.96;
li = (conf*sqrt((pai/2.0-1)*n)+n*1.0)*fit/((n-k)*1.0);
%li = prctile2(out95(:,9),1.0);
%li = 5
l = out95(:,9) <= li;
f = out95(l,:);


rect = [0.20,  0.20, 0.60, 0.60];
axes('position',rect)

% add the strike of the fault
strike = 90;
str = [180-strike 0 ; 360-strike 0];
pl = polar2(str(:,1)*pi/180,90-str(:,2),'.k');
set(pl,'LineWidth',0.2);
hold on


pl1 = polar2((f(:,2))*pi/180,90-f(:,1),'sk');
set(pl1,'LineWidth',1,'MarkerSize',6,'Markerfacecolor','w')
hold on
pl2 = polar2((f(:,4))*pi/180,90-f(:,3),'^b');
set(pl2,'LineWidth',1,'MarkerSize',6,'Markerfacecolor','w')
pl3 = polar2((f(:,6))*pi/180,90-f(:,5),'or');
set(pl3,'LineWidth',1,'MarkerSize',6,'Markerfacecolor','w')


i =  min(find(f(:,9) == min(f(:,9))));

pl = polar2(f(i,2)*pi/180,90-f(i,1),'sk');
set(pl,'LineWidth',2,'MarkerSize',12,'Markerfacecolor','w')
hold on
pl = polar2(f(i,4)*pi/180,90-f(i,3),'^k');
set(pl,'LineWidth',2,'MarkerSize',12,'Markerfacecolor','w')
pl = polar2(f(i,6)*pi/180,90-f(i,5),'ok');
set(pl,'LineWidth',2,'MarkerSize',12,'Markerfacecolor','w')

le = legend([pl1 pl2 pl3],'S1','S2','S3');
set(le,'pos',[0.1 0.7 0.15 0.1]);

te = text(0.9,0.95,[ 'R  =  ' num2str(f(i,8))],'Units','normalized',...
    'FontWeight','bold');
te = text(0.9,0.85,['Mis=  ' num2str(f(i,9))],'Units','normalized',...
    'FontWeight','bold');
te = text(0.9,0.90,['Phi=  ' num2str(f(i,7))],'Units','normalized',...
    'FontWeight','bold');
te = text(0.1,-0.10,[' ' num2str(f(i,1)) ' ' num2str(f(i,2)) ' / ' num2str(f(i,3)) ' ' num2str(f(i,4)) ' / ' num2str(f(i,5)) ' ' num2str(f(i,6))],'Units','normalized',...
    'FontWeight','normal','FontSize',10);


%matdraw

rect = [0.80,  0.05, 0.18, 0.18];
axes('position',rect)
[n,x]=histogram(f(:,8),0:0.1:1);
fillbar(x,n,'r')
title('R-values')
set(gca,'XLim',[0.05 0.95])
set(gca,'Color',[cb1 cb2 cb3])
set(gca,'FontSize',6,'FontWeight','normal',...
    'FontWeight','bold','LineWidth',0.3,...
    'Box','on','SortMethod','childorder')

uicontrol('Units','normal',...
    'Position',[.0 .93 .13 .06],'String','Plot in GMT ',...
     'Callback','plot95C')

set(gcf,'color','w');

return

% experiental code,
XI = (0:1:90);
YI = (0:1:360);
ZI = griddata(out95(:,1),out95(:,2),out95(:,9),XI,YI','linear');
figure
pcolor(XI,YI,ZI);
shading interp


figure
axes('pos',[ 0.15 0.15 0.7 0.7])
m_proj('stereographic','lat',90,'long',0,'radius',90);
[c,mc] = m_contour(YI,XI,ZI',10);
%set(mc(:),'LineStyle','none');
set(gca,'visible','on','FontSize',12,'FontWeight','bold',...
    'LineWidth',1.,'Box','on','TickDir','out','SortMethod','childorder');
m_grid('xtick',[0 30 60 90 120 150 180 -150 -120 -90 -60 -30 ],'tickdir','out','ytick',6,'linest','-.',...
    'yticklabel',[],'xticklabel',[180 150 120 90 60 30 0 330 300 270 240 210 ],'FontName','HelveticaBold',...
    'ylabeldir','middle');
%whitebg(gcf);
set(gcf,'Color','w')
caxis([ min(min(ZI)) max(max(ZI)) ] );

h5 = colorbar('vert');
set(h5,'visible','on','FontSize',12,'FontWeight','bold',...
    'LineWidth',1.,'Box','on','TickDir','out','SortMethod','childorder',...
    'pos',[0.85 0.25 0.015 0.5]);
