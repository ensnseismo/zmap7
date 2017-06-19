% This file plot a summary of the seismicity on one volcano
% on one wheet of paper.

% Stefan Wiemer   08/96
report_this_filefun(mfilename('fullpath'));

% lets start with a map

[existFlag,figNumber]=figure_exists('Seismicity Summary',1);
newMapWindowFlag=~existFlag;

% Set up the Seismicity Map window Enviroment
%
if newMapWindowFlag
    mapI = figure_w_normalized_uicontrolunits( ...
        'Name','Seismicity Summary',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'backingstore','on',...
        'NextPlot','add', ...
        'Visible','off', ...
        'Position',[ fipo(3)-600 fipo(4)-600 winx+200 winy+80]);

    if term  > 1;   whitebg([c1 c2 c3]); end
    stri1 = [file1];

    
    matdraw

else
end

% show the figure
%
figure_w_normalized_uicontrolunits(mapI)
reset(gca)
delete(gca);delete(gca);delete(gca);
delete(gca);delete(gca);delete(gca);
delete(gca);delete(gca);delete(gca);
watchon;
set(gca,'visible','off','SortMethod','childorder')
hold off

%set(set_ni3,'String',num2str(ni));
% find min and Maximum axes points
s1 = max(a(:,1));
s2 = min(a(:,1));
s3 = max(a(:,2));
s4 = min(a(:,2));
%ni = 100;
orient landscape
set(gcf,'PaperPosition',[ 1.0 1.0 8 6])
rect = [0.55,  0.50, 0.25, 0.30];
axis('equal')
axes('position',rect)
%
% find start and end time of catalogue "a"
%
t0b = a(1,3);
n = length(a(:,1));
teb = a(n,3) ;
tdiff =round(teb - t0b)*365/par1;


n = length(a);

% plot earthquakes (differnt colors for varous depth layers) as
% defined in "startzmap"
%
hold on

dep1 = -1;
dep2 = 1;
dep3 = 4;
deplo1 =plot(a(a(:,6)<=dep1,1),a(a(:,6)<=dep1,2),'.b');
set(deplo1,'MarkerSize',ms6,'Marker',ty1,'era','normal')
deplo2 =plot(a(a(:,6)<=dep2&a(:,6)>dep1,1),a(a(:,6)<=dep2&a(:,6)>dep1,2),'.g');
set(deplo2,'MarkerSize',ms6,'Marker',ty2,'era','normal');
deplo3 =plot(a(a(:,6)<=dep3&a(:,6)>dep2,1),a(a(:,6)<=dep3&a(:,6)>dep2,2),'.r');
set(deplo3,'MarkerSize',ms6,'Marker',ty3,'era','normal')
ls1 = sprintf('M < %3.1f ',dep1);
ls2 = sprintf('M < %3.1f ',dep2);
ls3 = sprintf('M < %3.1f ',dep3);


%le =legend('+b',ls1,'og',ls2,'xr',ls3);
%set(le,'position',[ 0.75 0.50 0.12 0.07],'FontSize',6)
axis([ s2 s1 s4 s3])
%xlabel('Longitude [deg]','FontWeight','normal','FontSize',fontsz.s)
%ylabel('Latitude [deg]','FontWeight','normal','FontSize',fontsz.s)
%strib = [  ' Map of   '  name '; '  num2str(t0b) ' to ' num2str(teb) ];
%title2(strib,'FontWeight','normal',...
% 'FontSize',fontsz.s,'Color','k')

h1 = gca;
if term > 1; set(gca,'Color',[cb1 cb2 cb3]); end

set(gca,'box','on',...
    'SortMethod','childorder','TickDir','out','FontWeight',...
    'normal','FontSize',fontsz.m,'Linewidth',1.2)

% next we plot a magnitude stem-plot
rect = [0.15, 0.10, 0.30, 0.20];
axes('position',rect)
h2 = gca;

hs = stem(a(:,3),a(:,6));
set(hs,'MarkerSize',4)
hold on

set(gca,'XLIM',[min(a(:,3)) max(a(:,3))+0.01])
xl = get(gca,'Xlim');

xlabel('Time in Years ]','FontWeight','normal','FontSize',fontsz.m)
ylabel('Magnitude','FontWeight','normal','FontSize',fontsz.m)

set(gca,'box','on',...
    'SortMethod','childorder','TickDir','out','FontWeight',...
    'normal','FontSize',fontsz.m,'Linewidth',1.2)

if term > 1; set(gca,'Color',[cb1 cb2 cb3]); end
%grid
hold off


% how about a histogram next

rect = [0.15, 0.30, 0.30, 0.15];
axes('position',rect)
h3 = gca;

[n,x] =histogram(a(:,3),(min(a(:,3)):par1:max(a(:,3))));
fillbar(x,n,'k')
ylabel('# per day','FontWeight','normal','FontSize',fontsz.m)

set(gca,'XTickLabels',[])
set(gca,'Xlim',xl)
if term > 1; set(gca,'Color',[cb1 cb2 cb3]); end

set(gca,'box','on',...
    'SortMethod','childorder','TickDir','out','FontWeight',...
    'normal','FontSize',fontsz.m,'Linewidth',1.2)
%grid

% now a time-depth plot
rect = [0.15, 0.60, 0.30, 0.20];
axes('position',rect)
h4 = gca;

deplo1 =plot(a(a(:,7)<=dep1,3),-a(a(:,7)<=dep1,7),'.b');
set(deplo1,'MarkerSize',ms6,'Marker',ty1,'era','normal')
hold on
deplo2 =plot(a(a(:,7)<=dep2&a(:,7)>dep1,3),-a(a(:,7)<=dep2&a(:,7)>dep1,7),'.g') ;
set(deplo2,'MarkerSize',ms6,'Marker',ty2,'era','normal');
deplo3 =plot(a(a(:,7)<=dep3&a(:,7)>dep2,3),-a(a(:,7)<=dep3&a(:,7)>dep2,7),'.r') ;
set(deplo3,'MarkerSize',ms6,'Marker',ty3,'era','normal')

hold on

ylabel('Depth in [km] ','FontWeight','normal','FontSize',fontsz.m)
%grid
set(gca,'XTickLabels',[])
set(gca,'XLim',xl)
set(gca,'box','on',...
    'SortMethod','childorder','TickDir','out','FontWeight',...
    'normal','FontSize',fontsz.m,'Linewidth',1.2)

if term > 1; set(gca,'Color',[cb1 cb2 cb3]); end


% next a cumulative number plot

rect = [0.15, 0.45, 0.30, 0.15];
axes('position',rect)
hold on
h3 = gca;

[n,x] =histogram(a(:,3),(min(a(:,3)):par1:max(a(:,3))));
fillbar(x,cumsum(n),'k')
ylabel('Cumulative # ','FontWeight','normal','FontSize',fontsz.m)
set(gca,'Xlim',xl)

set(gca,'XTickLabels',[])
set(gca,'Xlim',xl)
if term > 1; set(gca,'Color',[cb1 cb2 cb3]); end

set(gca,'box','on',...
    'SortMethod','childorder','TickDir','out','FontWeight',...
    'normal','FontSize',fontsz.m,'Linewidth',1.2)
%grid


% now plot a b-value distribution

rect = [0.55, 0.15, 0.25, 0.25];
axes('position',rect)

newcat =a;

avob

set(gca,'box','on',...
    'SortMethod','childorder','TickDir','out','FontWeight',...
    'normal','FontSize',fontsz.m,'Linewidth',1.2)

if term > 1; set(gca,'Color',[cb1 cb2 cb3]); end

watchoff
set(gcf,'PaperPosition',[ 0.1 0.1 11 9])
rect=[0 0 1 1];
h2 =axes('position',rect);
set(h2,'visible','off');
l = length(a(:,1));
txt1=text(.15, .85,[' ' num2str(floor(a(1,3))) '/'  num2str(a(1,4))  '/' ,...
    num2str(a(1,5)) ' - '  num2str(floor(a(l,3))) '/'  num2str(a(l,4))  '/'  num2str(a(l,5)) ]);
set(txt1,'FontWeight','bold','FontSize',14);
c = fix(clock);
txt1=text(.15, .82,['created: ' date '  ' num2str(c(4)) '.' num2str(c(5))  ] )   ;
set(txt1,'FontWeight','normal','FontSize',12)
