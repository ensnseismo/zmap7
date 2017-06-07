% This .m file "ctimeplot" plots the events select by "circle"
% or by other selection button as a cummultive number versus
% time plot in window 2.
% Time of events with a Magnitude greater than minmag will
% be shown on the curve.  Operates on newt2, resets  b  to newt2,
%     newcat is reset to:
%                       - "a" if either "Back" button or "Close" button is         %                          pressed.
%                       - newt2 if "Save as Newcat" button is pressed.
%Last modification 8/95
welcome(' ','Plotting cumulative number plot...');
think
report_this_filefun(mfilename('fullpath'));

% This is the info window text
%
ttlStr='The Cumulative Number Window                  ';
hlpStr1= ...
    ['                                                     '
    ' This window displays the seismicity in the sel-     '
    ' ected area as a cumulative number plot.             '
    ' Options from the Tools menu:                        '
    ' Cuts in magnitude and  depth: Opens input para-     '
    '    meter window                                     '
    ' Decluster the catalog: Will ask for declustering    '
    '     input parameter and decluster the catalog.      '
    ' AS(t): Evaluates significance of seismicity rate    '
    '      changes using the AS(t) function. See the      '
    '      Users Guide for details                        '
    ' LTA(t), Rubberband: dito                            '
    ' Overlay another curve (hold): Allows you to plot    '
    '       one or several more curves in the same plot.  '
    '       select "Overlay..." and then selext a new     '
    '       subset of data in the map window              '
    ' Compare two rates: start a comparison and moddeling '
    '       of two seimicity rates based on the assumption'
    '       of a constant b-value. Will calculate         '
    '       Magnitude Signature. Will ask you for four    '
    '       times.                                        '
    '                                                     '];
hlpStr2= ...
    ['                                                      '
    ' b-value estimation:    just that                     '
    ' p-value plot: Lets you estimate the p-value of an    '
    ' aftershock sequence.                                 '
    ' Save cumulative number cure: Will save the curve in  '
    '        an ASCII file                                 '
    '                                                      '
    ' The "Keep as newcat" button in the lower right corner'
    ' will make the currently selected subset of eartquakes'
    ' in space, magnitude and depth the current one. This  '
    ' will also redraw the Map window!                     '
    '                                                      '
    ' The "Back" button will plot the original cumulative  '
    ' number curve without statistics again.               '
    '                                                      '];

global par1 pplot tmp1 tmp2 tmp3 tmp4 difp loopcheck Info_p
global cplot mess tiplo2 cum newt2 ho statime maxde minde
global maxma2 minma2


% Find out of figure already exists
%
[existFlag,figNumber]=figure_exists('Cumulative Number',1);
newCumWindowFlag=~existFlag;
cum = figNumber;

% Set up the Cumulative Number window

if newCumWindowFlag
    cum = figure_w_normalized_uicontrolunits( ...
        'Name','Cumulative Number',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'NextPlot','replace', ...
        'backingstore','on',...
        'Visible','off', ...
        'Position',[ 100 100 winx-100 winy-20]);

    matdraw

    options = uimenu('Label','Tools ');

    uimenu(options,'Label','Cuts in magnitude and depth', 'Callback','inpu2')
    uimenu (options,'Label','Decluster the catalog', 'Callback','inpude;')
    iwl = iwl2*365/par1;
    uimenu(options,'Label','AS(t)function',...
         'Callback','set(gcf,''Pointer'',''watch'');sta = ''ast'';newsta')
    uimenu(options,'Label','Rubberband function',...
         'Callback','set(gcf,''Pointer'',''watch'');sta = ''rub'';newsta')
    uimenu(options,'Label','LTA(t) function ',...
         'Callback','set(gcf,''Pointer'',''watch'');sta = ''lta'';newsta')
    uimenu(options,'Label','Overlay another curve (hold)', 'Callback','ho = ''hold''; ')
    uimenu(options,'Label','Compare two rates (fit)', 'Callback','dispma2')
    uimenu(options,'Label','Compare two rates ( No fit)', 'Callback','dispma3')
    op4 = uimenu(options,'Label','b-value estimation');
    uimenu(op4,'Label','manual', 'Callback','bfitnew(newt2)')
    uimenu(op4,'Label','automatic', 'Callback','bdiff(newt2)')
    uimenu(op4,'Label','b with depth', 'Callback','bwithde')
    uimenu(op4,'Label','b with time', 'Callback','bwithti')

    op5 = uimenu(options,'Label','p-value estimation');
    uimenu(op5,'Label','manual', 'Callback','global hndl1;ttcat = newt2; clpval(1)')
    uimenu(op5,'Label','automatic', 'Callback','global hndl1;ttcat =newt2; clpval(3)')
    uimenu(options,'Label','get coordinates with Cursor', 'Callback','gi = ginput(1),plot(gi(1),gi(2),''+'');')
    uimenu(options,'Label','Cumlative Moment Release ', 'Callback','morel')
    uimenu(options,'Label','Time Selection', 'Callback','timeselect(4);ctimeplot;');
    %uimenu(options,'Label',' Magnitude signature', 'Callback','dispma0')
    uimenu(options,'Label','Save cumulative number curve', 'Callback','eval(calSave)')
    calSave =...
        [ 'welcome(''Save Data'',''  '');think;',...
        '[file1,path1] = uigetfile([hodi hodi fs ''out'' fs ''*.dat''], ''Earthquake Datafile'');',...
        'out=[xt;cumu2]'';',...
        ' sapa = [''save '' path1 file1 '' out  -ascii''];',...
        'eval(sapa) ; done'];


    callbackStr= ...
        [];

    uicontrol('Units','normal',...
        'Position',[.0  .85 .08 .06],'String','Info ',...
         'Callback','zmaphelp(ttlStr,hlpStr1,hlpStr2)')

    uicontrol('Units','normal',...
        'Position',[.0  .75 .08 .06],'String','Close ',...
         'Callback','newcat=a;f1=gcf; f2=gpf; close(f1);if f1~=f2, figure_w_normalized_uicontrolunits(f2); end')

    uicontrol('Units','normal',...
        'Position',[.0  .93 .08 .06],'String','Print ',...
         'Callback','myprint')


    uicontrol('Units','normal','Position',[.9 .10 .1 .05],'String','Back', 'Callback','newcat = newcat; newt2 = newcat; stri = ['' '']; stri1 = ['' '']; ctimeplot')

    uicontrol(,'Units','normal','Position',[.65 .01 .3 .07],'String','Keep as newcat', 'Callback','newcat = newt2;a=newt2;csubcata')


end
%end;    if figure exist

if ho == 'hold'
    cumu = 0:1:(tdiff*365/par1)+2;
    cumu2 = 0:1:(tdiff*365/par1)-1;
    cumu = cumu * 0;
    cumu2 = cumu2 * 0;
    n = length(newt2(:,1));
    [cumu, xt] = hist(newt2(:,3),(t0b:par1/365:teb));
    cumu2 = cumsum(cumu);


    hold on
    axes(ht)
    tiplo2 = plot(xt,cumu2,'r');
    set(tiplo2,'LineWidth',2.5)

    ho = 'noho'
    return
end

figure_w_normalized_uicontrolunits(cum)
delete(gca)
delete(gca)
reset(gca)
dele = 'delete(sicum)';er = 'disp('' '')'; eval(dele,er);
cla
hold off
watchon;

set(gca,'visible','off','FontSize',fontsz.m,'FontWeight','bold',...
    'FontWeight','bold','LineWidth',1.5,...
    'Box','on','SortMethod','childorder')

if isempty(newcat), newcat =a; end

% select big events ( > minmag)
%
l = newt2(:,6) > minmag;
big = newt2(l,:);
%big=[];
%calculate start -end time of overall catalog
%R
statime=[];
par2=par1;
t0b = min(a(:,3));
n = length(newt2(:,1));
teb = max(a(:,3));
ttdif=(teb - t0b)*365;
if ttdif>10                 %select bin length respective to time in catalog
    par1 = ceil(ttdif/300);
elseif ttdif<=10  &&  ttdif>1
    par1 = 0.1;
elseif ttdif<=1
    par1 = 0.01;
end


if par1>=1
    tdiff = round((teb - t0b)*365/par1);
    %tdiff = round(teb - t0b);
else
    tdiff = (teb-t0b)*365/par1;
end
% set arrays to zero
%
%if par1>=1
% cumu = 0:1:(tdiff*365/par1)+2;
% cumu2 = 0:1:(tdiff*365/par1)-1;
%else
%  cumu = 0:par1:tdiff+2*par1;
%  cumu2 =  0:par1:tdiff-1;
%end
% cumu = cumu * 0;
% cumu2 = cumu2 * 0;

%
% calculate cumulative number versus time and bin it
%
n = length(newt2(:,1));
if par1 >=1
    [cumu, xt] = hist(newt2(:,3),(t0b:par1/365:teb));
else
    [cumu, xt] = hist((newt2(:,3)-newt2(1,3)+par1/365)*365,(0:par1:(tdiff+2*par1)));
end
cumu2=cumsum(cumu);
par1
% plot time series
%
%orient tall
set(gcf,'PaperPosition',[0.5 0.5 6.5 9.5])
rect = [0.25,  0.18, 0.60, 0.70];
axes('position',rect)
hold on
%tiplo = plot(xt,cumu2,'ob');
set(gca,'visible','off')
tiplo2 = plot(xt,cumu2,'b');
set(tiplo2,'LineWidth',2.5)


% plot big events on curve
%
if par1>=1
    if ~isempty(big)
        if ceil(big(:,3) -t0b) > 0
            f = cumu2(ceil((big(:,3) -t0b)*365/par1));
            bigplo = plot(big(:,3),f,'xr');
            set(bigplo,'MarkerSize',10,'LineWidth',2.5)
            stri4 = [];
            [le1,le2] = size(big);
            for i = 1:le1
                s = sprintf('  M=%3.1f',big(i,6));
                stri4 = [stri4 ; s];
            end   % for i

            te1 = text(big(:,3),f,stri4);
            set(te1,'FontWeight','bold','Color','m','FontSize',fontsz.s)
        end

        %option to plot the location of big events in the map
        %
        % figure_w_normalized_uicontrolunits(map)
        % plog = plot(big(:,1),big(:,2),'or','EraseMode','xor');
        %set(plog,'MarkerSize',ms10,'LineWidth',2.0)
        %figure_w_normalized_uicontrolunits(cum)

    end
end %if big

if exist('stri') > 0
    v = axis;
    %if par1>=1
    % axis([ v(1) ceil(teb) v(3) v(4)+0.05*v(4)]);
    %end
    tea = text(v(1)+0.5,v(4)*0.9,stri) ;
    set(tea,'FontSize',fontsz.m,'Color','k','FontWeight','bold')
else
    strib = [file1];
end %% if stri

strib = [name];

title2(strib,'FontWeight','bold',...
    'FontSize',fontsz.l,...
    'Color','k')

grid
if par1>=1
    xlabel('Time in years ','FontWeight','bold','FontSize',fontsz.m)
else
    statime=newt2(1,3)-par1/365;
    xlabel(['Time in days relative to ',num2str(statime)],'FontWeight','bold','FontSize',fontsz.m)
end
ylabel('Cumulative Number ','FontWeight','bold','FontSize',fontsz.m)
ht = gca;
if term > 1; set(gca,'Color',[cb1 cb2 cb3]);end

%clear strib stri4 s l f bigplo plog tea v
% Make the figure visible
%
set(gca,'visible','on','FontSize',fontsz.m,'FontWeight','bold',...
    'FontWeight','bold','LineWidth',1.5,...
    'Box','on')
figure_w_normalized_uicontrolunits(cum);
if term == 1 ; whitebg(cum,[0 0 0 ]); end
%sicum = signatur('ZMAP','',[0.65 0.98 .04]);
%set(sicum,'Color','b')
axes(ht);
set(cum,'Visible','on');
watchoff(cum)
watchoff(map)
welcome(' ',' ')
par1=par2;
done

