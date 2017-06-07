% This .m file "view_maxz.m" plots the maxz LTA values calculated
% with maxzlta.m or other similar values as a color map
% needs re3, gx, gy, stri
%

report_this_filefun(mfilename('fullpath'));

% define size of the plot etc.
%
co = 'w';


% Find out of figure already exists
%
[existFlag,figNumber]=figure_exists('b-value cross-section',1);
newbmapcWindowFlag=~existFlag;

% This is the info window text
%
ttlStr='The Z-Value Map Window                        ';
hlpStr1zmap= ...
    ['                                                '
    ' This window displays seismicity rate changes   '
    ' as z-values using a color code. Negative       '
    ' z-values indicate an increase in the seismicity'
    ' rate, positive values a decrease.              '
    ' Some of the menu-bar options are               '
    ' described below:                               '
    '                                                '
    ' Threshold: You can set the maximum size that   '
    '   a volume is allowed to have in order to be   '
    '   displayed in the map. Therefore, areas with  '
    '   a low seismicity rate are not displayed.     '
    '   edit the size (in km) and click the mouse    '
    '   outside the edit window.                     '
    'FixAx: You can chose the minimum and maximum    '
    '        values of the color-legend used.        '
    'Polygon: You can select earthquakes in a        '
    ' polygon either by entering the coordinates or  '
    ' defining the corners with the mouse            '];
hlpStr2zmap= ...
    ['                                                '
    'Circle: Select earthquakes in a circular volume:'
    '      Ni, the number of selected earthquakes can'
    '      be edited in the upper right corner of the'
    '      window.                                   '
    ' Refresh Window: Redraws the figure, erases     '
    '       selected events.                         '

    ' zoom: Selecting Axis -> zoom on allows you to  '
    '       zoom into a region. Click and drag with  '
    '       the left mouse button. type <help zoom>  '
    '       for details.                             '
    ' Aspect: select one of the aspect ratio options '
    ' Text: You can select text items by clicking.The'
    '       selected text can be rotated, moved, you '
    '       can change the font size etc.            '
    '       Double click on text allows editing it.  '
    '                                                '
    '                                                '];

% Set up the Seismicity Map window Enviroment
%
if newbmapcWindowFlag
    bmapc = figure_w_normalized_uicontrolunits( ...
        'Name','b-value cross-section',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'backingstore','on',...
        'Visible','off', ...
        'Position',[ fipo(3)-600 fipo(4)-400 winx winy]);
    % make menu bar
    matdraw

    add_symbol_menu('eqc_plot');


    uicontrol('Units','normal',...
        'Position',[.0 .93 .08 .06],'String','Print ',...
         'Callback','myprint')

    callbackStr= ...
        ['f1=gcf; f2=gpf; set(f1,''Visible'',''off'');close(bmapc);', ...
        'if f1~=f2, figure_w_normalized_uicontrolunits(map);done; end'];

    uicontrol('Units','normal',...
        'Position',[.0 .75 .08 .06],'String','Close ',...
         'Callback','eval(callbackStr)')

    uicontrol('Units','normal',...
        'Position',[.0 .85 .08 .06],'String','Info ',...
         'Callback','zmaphelp(ttlStr,hlpStr1zmap,hlpStr2zmap)')


    options = uimenu('Label',' Select ');
    uimenu(options,'Label','Refresh ', 'Callback','view_bv2')
    uimenu(options,'Label','Select EQ in Circle',...
         'Callback',' h1 = gca;ho = ''noho'';cicros;watchoff(bmapc)')
    uimenu(options,'Label','Select EQ in Circle - Overlay existing plot', 'Callback','h1 = gca;ho = ''hold'';cicros;watchoff(bmapc)')

    op1 = uimenu('Label',' Tools ');
    uimenu(op1,'Label','Fix color (z) scale', 'Callback','fixax2 ')
    uimenu(op1,'Label','Histogram of b-values', 'Callback','zhist')
    uimenu(op1,'Label','Show  b-value Map', 'Callback',' re3 = old; view_bv2')
    uimenu(op1,'Label','Show  b(mean) map', 'Callback',' re3 = 0.4343./(meg-min(newa(:,6))); view_bv2')
    uimenu(op1,'Label','Show  mean magnitude map', 'Callback',' re3 = meg; view_bv2')
    uimenu(op1,'Label','Show  mag of completness map', 'Callback',' re3 = old1; view_bv2')
    uimenu(op1,'Label','Show Resolution Map', 'Callback','re3 = r; view_bv2')
    uimenu(op1,'Label','Show Grid ',...
         'Callback',' [X,Y] = meshgrid(gx,gy);hold on;plot(X,Y,''+k'')')
    uimenu(op1,'Label','Show Circles ', 'Callback','plotcirc')
    uimenu(op1,'Label','Colormap InvertGray', 'Callback','g=gray; g = g(64:-1:1,:);colormap(g);brighten(.4)')
    uimenu(op1,'Label','shading flat', 'Callback','axes(hzma); shading flat')
    uimenu(op1,'Label','shading interpolated',...
         'Callback','axes(hzma); shading interp')


    uicontrol('Units','normal',...
        'Position',[.92 .80 .08 .05],'String','set ni',...
         'Callback','ni=str2num(get(set_nia,''String''));''String'',num2str(ni);')


    set_nia = uicontrol('style','edit','value',ni,'string',num2str(ni));
    set(set_nia,'Callback',' ');
    set(set_nia,'units','norm','pos',[.94 .85 .06 .05],'min',10,'max',10000);
    nilabel = uicontrol('style','text','units','norm','pos',[.90 .85 .04 .05]);
    set(nilabel,'string','ni:','background',[.7 .7 .7]);

    % tx = text(0.07,0.95,[name],'Units','Norm','FontSize',18,'Color','k','FontWeight','bold');

    tresh = max(max(r)); re4 = re3;
    nilabel2 = uicontrol('style','text','units','norm','pos',[.60 .92 .25 .06]);
    set(nilabel2,'string','MinRad (in km):','background',[c1 c2 c3]);
    set_ni2 = uicontrol('style','edit','value',tresh,'string',num2str(tresh),...
        'background','y');
    set(set_ni2,'Callback','tresh=str2double(get(set_ni2,''String'')); set(set_ni2,''String'',num2str(tresh))');
    set(set_ni2,'units','norm','pos',[.85 .92 .08 .06],'min',0.01,'max',10000);

    uicontrol('Units','normal',...
        'Position',[.95 .93 .05 .05],'String','Go ',...
         'Callback','think;pause(1);re4 =re3; view_bv2')

end   % This is the end of the figure setup

% Now lets plot the color-map of the z-value
%
figure_w_normalized_uicontrolunits(bmapc)
delete(gca)
delete(gca)
delete(gca)
try
    delete(sizmap)
catch ME
    error_handler(ME, ' ');
end
reset(gca)
cla
hold off
watchon;
set(gca,'visible','off','FontSize',fontsz.m,'FontWeight','bold',...
    'FontWeight','bold','LineWidth',1.5,...
    'Box','on','SortMethod','childorder')

rect = [0.18,  0.00, 0.7, 0.75];
rect1 = rect;

% set values gretaer tresh = nan
%
re4 = re3;
l = r > tresh;
re4(l) = zeros(1,length(find(l)))*nan;

% plot image
%
orient portrait
%set(gcf,'PaperPosition', [2. 1 7.0 5.0])

axes('position',rect)
hold on
pco1 = pcolor(gx,gy,re4);

axis([ min(gx) max(gx) min(gy) max(gy)])
axis image
hold on
shading interp
if term == 1
    colormap(gray)
else
    h = hsv(64);
    h = h(57:-1:1,:);
    colormap(h)
end
if fre == 1
    caxis([fix1 fix2])
end

ylabel('depth in [km]','FontWeight','bold','FontSize',fontsz.m)

% ploeqc = plot(newa(:,length(newa(1,:))),-newa(:,7),'.k')

if ~isempty(maix)
    pl = plot(maix,maiy,'*k')
    set(pl,'MarkerSize',12,'LineWidth',2)
end

%if ~isempty(maex)
pl = plot(maex,-maey,'xw')
set(pl,'MarkerSize',10,'LineWidth',2)
%end

set(gca,'visible','on','FontSize',fontsz.m,'FontWeight','bold',...
    'FontWeight','bold','LineWidth',1.5,...
    'Box','on','TickDir','out')
h1 = gca;
hzma = gca;

% Create a colobar
%
h5 = colorbar('vert');
set(h5,'Pos',[0.80 0.40 0.02 0.15],...
    'FontWeight','bold','FontSize',fontsz.m)
%h5 = colorbar('horiz');
%set(h5,'Pos',[0.25 0.05 0.5 0.05],...
%'FontWeight','bold','FontSize',fontsz.m)


% Make the figure visible
%
set(gca,'visible','on','FontSize',fontsz.m,'FontWeight','bold',...
    'FontWeight','bold','LineWidth',1.5,...
    'Box','on','TickDir','out')


rect = [0.18,  -0.20, 0.7, 0.75];
rect1 = rect;

% set values gretaer tresh = nan
%
re4 = ret;
l = r > tresh;
re4(l) = zeros(1,length(find(l)))*nan;
axes('position',rect)
hold on
pco1 = pcolor(gx,gy,re4);

axis([ min(gx) max(gx) min(gy) max(gy)])
axis image
hold on
shading interp
h = hsv(64);
h = h(57:-1:1,:);
colormap(h)
%end
caxis([20 200])

xlabel('Distance in [km]','FontWeight','bold','FontSize',fontsz.m)
ylabel('depth in [km]','FontWeight','bold','FontSize',fontsz.m)

% plot overlay
%
% ploeqc = plot(newa(:,length(newa(1,:))),-newa(:,7),'.k')

pl = plot(maex,-maey,'xw')
set(pl,'MarkerSize',10,'LineWidth',2)

set(gca,'visible','on','FontSize',fontsz.m,'FontWeight','bold',...
    'FontWeight','bold','LineWidth',1.5,...
    'Box','on','TickDir','out')
h1 = gca;
hzma = gca;

% Create a colobar
%
h5 = colorbar('vert');
set(h5,'Pos',[0.80 0.10 0.02 0.15],...
    'FontWeight','bold','FontSize',fontsz.m)


% Make the figure visible
%
set(gca,'visible','on','FontSize',fontsz.m,'FontWeight','bold',...
    'FontWeight','bold','LineWidth',1.5,...
    'Box','on','TickDir','out')


rect = [0.18,  0.40, 0.7, 0.75];
axes('position',rect)
hold on
ploeqc = plot(newa(:,length(newa(1,:))),-newa(:,7),'+r');
hold on
set(ploeqc,'Tag','eqc_plot','MarkerSize',8,'LineWidth',1)
hold on

axis([ min(gx) max(gx) min(gy) max(gy)])
axis image
hold on

ylabel('depth in [km]','FontWeight','bold','FontSize',fontsz.m)

% plot overlay
%
if ~isempty(maix)
    pl = plot(maix,maiy,'*k')
    set(pl,'MarkerSize',12,'LineWidth',2)
end

%if ~isempty(maex)
pl = plot(maex,-maey,'kx')
set(pl,'MarkerSize',10,'LineWidth',2)
%end

set(gca,'visible','on','FontSize',fontsz.m,'FontWeight','bold',...
    'FontWeight','bold','LineWidth',1.5,...
    'Box','on','TickDir','out','Color',[1 1 0.6])


figure_w_normalized_uicontrolunits(bmapc);
watchoff(bmapc)
done
