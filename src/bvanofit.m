%
%   Calculates Freq-Mag functions (b-value) for two time-segments
%   finds best fit to the foreground for a modified background
%   assuming a change in time of the following types:
%   Mnew = Mold + d     , i.e. Simple magnitude shift
%   Mnew = c*Mold + d   , i.e. Mag stretch plus shift
%   Nnew = fac*Nold     , i.e. Rate change (N = number of events)
%                                      R. Zuniga IGF-UNAM/GI-UAF  6/94
report_this_filefun(mfilename('fullpath'));
ms3 = 5;
newcat = newt2;

% This is the info window text
%
ttlStr='Comparing Seismicity rates ';
hlpStr1map= ...
    ['                                                '
    ' To be Implemented                              '
    '                                                '];
% Find out of figure already exists
%
[existFlag,figNumber]=figure_exists('Compare two rates',1);
newCompWindowFlag=~existFlag;

% Set up the Seismicity Map window Enviroment
%
if newCompWindowFlag
    bvfig= figure_w_normalized_uicontrolunits( ...
        'Name','Compare two rates',...
        'NumberTitle','off', ...
        'backingstore','on',...
        'Visible','on', ...
        'Position',[ fipo(3)-600 fipo(4)-600 winx winy+200]);


    uicontrol('Units','normal',...
        'Position',[.0 .93 .08 .06],'String','Print ',...
         'Callback','myprint')

    uicontrol('Units','normal',...
        'Position',[.0 .75 .08 .06],'String','Close ',...
         'Callback','f1=gcf; f2=gpf;set(f1,''Visible'',''off'');if f1~=f2, welcome;done; end')

    uicontrol('Units','normal',...
        'Position',[.0 .85 .08 .06],'String','Info ',...
         'Callback','zmaphelp(ttlStr,hlpStr1map,hlpStr2map,hlpStr3map)')
    axis off
    matdraw

end % if figure exits

figure_w_normalized_uicontrolunits(bvfig)
delete(gca)
delete(gca)
delete(gca)
delete(gca)
delete(gca)
delete(gca)
delete(gca)
delete(gca)
delete(gca)
delete(gca)
global p
backg = [ ] ;
foreg = [ ] ;
format short;

if isempty(newcat), newcat = a; end
maxmag = max(newcat(:,6));
minmag2 = min(newcat(:,6));
t0b = min(newcat(:,3));
teb = max(newcat(:,3));
n = length(newcat(:,1));
tdiff = round(teb - t0b);

% number of mag units
nmagu = (maxmag*10)+1;

bval = zeros(1,nmagu);
bval2 = zeros(1,nmagu);
bvalsum = zeros(1,nmagu);
bvalsum2 = zeros(1,nmagu);
bvalsum3 = zeros(1,nmagu);
bvalsum4 = zeros(1,nmagu);
backg_ab = [ ];
foreg_ab = [ ];
backg_be = [ ];
foreg_be = [ ];
backg = [ ];
foreg = [ ];
backg_beN = [ ];
backg_abN = [ ];
td12 = t2p(1) - t1p(1);
td34 = t4p(1) - t3p(1);

l = newcat(:,3) > t1p(1) & newcat(:,3) < t2p(1) ;
backg =  newcat(l,:);
[bval,xt2] = hist(backg(:,6),(minmag2:0.1:maxmag));
bval = bval /td12;                      % normalization
bvalsum = cumsum(bval);                        % N for M <=
bvalsum3 = cumsum(bval(length(bval):-1:1));    % N for M >= (counted backwards)
xt3 = (maxmag:-0.1:minmag2);
[cumux, xt] = hist(newcat(l,3),t1p(1):par1/365:t2p(1));

l = newcat(:,3) > t3p(1) & newcat(:,3) < t4p(1) ;
foreg = newcat(l,:);
bval2 = histogram(foreg(:,6),(minmag2:0.1:maxmag));
bval2 = bval2/td34;
bvalsum2 = cumsum(bval2);
bvalsum4 = cumsum(bval2(length(bval2):-1:1));
[cumux2, xt] = hist(newcat(l,3),t3p(1):par1/365:t4p(1));
mean1 = mean(cumux);
mean2 = mean(cumux2);
var1 = cov(cumux);
var2 = cov(cumux2);
zscore = (mean1 - mean2)/(sqrt(var1/length(cumux)+var2/length(cumux2)));

%change in percent
R1 = length(backg(:,1))/(t2p(1)-t1p(1))
R2 = length(foreg(:,1))/(t4p(1)-t3p(1));
change = -((R1-R2)/R1)*100


backg_be = log10(bvalsum);
backg_ab = log10(bvalsum3);
foreg_be = log10(bvalsum2);
foreg_ab = log10(bvalsum4);

% plot b-value plot
%
orient tall
set(gcf,'PaperPosition',[2 1 5.5 7.5])
rect = [0.20,  0.7, 0.70, 0.25];           % plot Freq-Mag curves
axes('position',rect)
hold on
figure_w_normalized_uicontrolunits(bvfig)
%pl = semilogy(xt2,bvalsum,'om');
%set(pl,'MarkerSize',[ms3])
%semilogy(xt2,bvalsum,'-.m')
hold on
%pl = semilogy(xt2,bvalsum2,'xb');
%set(pl,'MarkerSize',[ms3])
%semilogy(xt2,bvalsum2,'b')
pl = semilogy(xt3,bvalsum4,'xb');
set(gca,'Yscale','log')
hold on
set(pl,'MarkerSize',[ms3])
semilogy(xt3,bvalsum4,'b')
pl = semilogy(xt3,bvalsum3,'om');
set(pl,'MarkerSize',[ms3])
semilogy(xt3,bvalsum3,'-.m')
te1 = max([bvalsum  bvalsum2 bvalsum4 bvalsum3]);
te1 = te1 - 0.2*te1;

%xlabel('Magnitude','FontSize',fontsz.s,'FontWeight','bold')
ylabel('Cum. rate/year','FontSize',fontsz.s,'FontWeight','bold')
%title([file1 '   o: ' num2str(t1p(1),6) ' - ' num2str(t2p(1),6) '     x: ' num2str(t3p(1),6) ' - '  num2str(t4p(1),6) ],'FontSize',fontsz.s,'FontWeight','bold','Color','k')
str = [ '   o: ' num2str(t1p(1),6) ' - ' num2str(t2p(1),4) '     x: ' num2str(t3p(1),6) ' - '  num2str(t4p(1),6) ' ; Change in %: ' num2str(change,6) ];

title(str,'FontSize',fontsz.s,'FontWeight','bold')
%  find b-values;
set(gca,'box','on',...
    'SortMethod','childorder','TickDir','out','FontWeight',...
    'bold','FontSize',fontsz.s,'Linewidth',1.0)
p1 = gca;


% Plot histogram
%
%set(gca,'Color',[cb1 cb2 cb3])

rect = [0.20,  0.40 0.70, 0.25];
axes('position',rect)
pl = plot(xt2,bval2,'xb');
set(pl,'MarkerSize',[ms3],'LineWidth',1.0)
hold on
pl = plot(xt2,bval,'om');
set(pl,'MarkerSize',[ms3],'LineWidth',1.0)
pl = plot(xt2,bval,'-.m');
set(pl,'MarkerSize',[ms3],'LineWidth',1.0)
pl = plot(xt2,bval2,'b');
set(pl,'MarkerSize',[ms3],'LineWidth',1.0)
disp([' Summation: ' num2str(sum(bval-bval2))])
%bar(xt2,bval,'om')
%bar(xt2,bval,'-.m')
%bar(xt2,bval2,'b')
v = axis;
xlabel('Magnitude ','FontSize',fontsz.s,'FontWeight','bold')
ylabel('rate/year','FontSize',fontsz.s,'FontWeight','bold')
set(gca,'box','on',...
    'SortMethod','childorder','TickDir','out','FontWeight',...
    'bold','FontSize',fontsz.s,'Linewidth',1.0)

uic = uicontrol('Units','normal','Position',[.35 .15 .30 .07],'String','Magnitude Signature? ', 'Callback','delete(uic);synsig3');

watchoff;watchoff(mess)

% Plot he b-value comparison
ho = 'noho';
bdiff(backg)
ho = 'hold'
bdiff(foreg)


