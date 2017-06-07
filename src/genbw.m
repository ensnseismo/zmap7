% Matlab script to write output from genas to a file.
% writes two files: one for results for magnitudes and below
% another for magnitudes and above.
%
report_this_filefun(mfilename('fullpath'));

figure
clf ;

[tbin,zmag,zval] = find(ZBEL);           % deal with sparse matrix results
xtz = t0b + (tbin*par1/365);
zmag = minmg+(zmag-1)*magstep;
[xx,l] = sort(xtz);                     % sort in time
xtz = xtz(l);
zmag = zmag(l);
zval = zval(l);
tbin = tbin(l);
Z = [tbin'; xtz'; zmag'; zval'];

rect = [0.15 0.15 0.3 0.7];
axes('pos',[rect]);
set(gca,'FontSize',fontsz.m,'FontWeight','normal');

if length(Z(1,:)) > 0
    l = Z(4,:)  > 6; Z(4,l)  = Z(4,l)*0+6 ;
    l = Z(4,:)  < -6; Z(4,l)  = Z(4,l)*0-6 ;
    for i = 1:length(Z(1,:))
        if Z(4,i) > 0
            pl = plot(Z(3,i),Z(2,i),'+k');
        else
            pl = plot(Z(3,i),Z(2,i),'ok');
        end
        set(pl,'MarkerSize',abs(Z(4,i)),'LineWidth',abs(Z(4,i)/3))
        set(pl,'MarkerFaceColor','w','MarkerEdgeColor','k');

        hold on
    end
end

axis([ minmg maxmg t0b teb])


ylabel('Time (yrs)','FontWeight','normal','FontSize',fontsz.m);
xlabel('Mag <','FontSize',fontsz.m,'FontWeight','normal');
set(gca,'FontSize',fontsz.m,'FontWeight','normal',...
    'Ticklength',[0.02 0.02],'LineWidth',1.0,...
    'Box','on','SortMethod','childorder','TickDir','out')

set(gca,'Color',[ cb1 cb2 cb3])


[tbin,zmag,zval] = find(ZABO);
xtz = t0b + (tbin*par1/365);
zmag = minmg+(zmag-1)*magstep;
[xx,l] = sort(xtz);                     % sort in time
xtz = xtz(l);
zmag = zmag(l);
zval = zval(l);
tbin = tbin(l);
Z = [tbin'; xtz'; zmag'; zval'];

rect = [0.45 0.15 0.3 0.7];
axes('pos',[rect]);
set(gca,'FontSize',fontsz.m,'FontWeight','normal',...
    'Ticklength',[0.02 0.02],'LineWidth',1.0,...
    'Box','on','SortMethod','childorder','TickDir','out')

if length(Z(1,:)) > 0
    l = Z(4,:)  > 6; Z(4,l)  = Z(4,l)*0+6 ;
    l = Z(4,:)  < -6; Z(4,l)  = Z(4,l)*0-6 ;

    for i = 1:length(Z(1,:))
        if Z(4,i) > 0
            pl = plot(Z(3,i),Z(2,i),'+k');
        else
            pl = plot(Z(3,i),Z(2,i),'ok');
        end
        hold on
        set(pl,'MarkerSize',abs(Z(4,i)),'LineWidth',abs(Z(4,i)/3))
        set(pl,'MarkerFaceColor','w','MarkerEdgeColor','k');
    end
end

axis([ minmg maxmg t0b teb])
xlabel('Mag >','FontSize',fontsz.m,'FontWeight','normal');
set(gca,'Yticklabels',[])

set(gca,'FontSize',fontsz.m,'FontWeight','normal',...
    'Ticklength',[0.02 0.02],'LineWidth',1.0,...
    'Box','on','SortMethod','childorder','TickDir','out')
%set(gca,'Color',[ cb1 cb2 cb3])
set(gcf,'Color',[c1 c2 c3])

te = text(1.1,0.9,'Positive z: + ','Units','normalized','FontWeight','normal');
te = text(1.1,0.8,'Negative z: o ','Units','normalized','FontWeight','normal');



uicontrol('Units','normal',...
    'Position',[.0 .85 .08 .06],'String','Info ',...
     'Callback','infoz(1)');

matdraw
