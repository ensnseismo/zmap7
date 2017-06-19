figure
report_this_filefun(mfilename('fullpath'));
tr2 = [];
tr2u = [];
tr2l = [];
for m = max(newt2(:,6))-1:0.1:max(newt2(:,6))+2
    %set si to 0 if not definded
    if isempty(si)
        si=0;
    end

    tr = (teb-t0b)/(10^(aw-bw*m));
    tru = (teb-t0b)/(10^(aw-(bw+si)*m));
    trl = (teb-t0b)/(10^(aw-(bw-si)*m));
    tr2 = [tr2 ; tr  m];
    tr2u = [tr2u ; tru  m];
    tr2l = [tr2l ; trl  m];
end

pl =  plot(tr2(:,2),tr2(:,1),'k');
set(pl,'LineWidth',2.0)
hold on
%pl =  plot(tr2u(:,2),tr2u(:,1),'b-.');
%set(pl,'LineWidth',2.0)
%pl =  plot(tr2l(:,2),tr2l(:,1),'g-.');
%set(pl,'LineWidth',2.0)
grid
%set(pl,'LineWidth',2.0)
set(gca,'Yscale','log');

set(gca,'box','on',...
    'SortMethod','childorder','TickDir','out','FontWeight',...
    'bold','FontSize',fontsz.m,'Linewidth',1.2,'Ticklength',[0.02 0.02])

ylabel('Recurrence Time [yrs] ')
xlabel('Magnitude ')
set(gcf,'color','w');set(gca,'color','w');


matdraw


figure
pl =  plot(tr2(:,2),1./tr2(:,1),'k');
set(pl,'LineWidth',2.0)
hold on
%pl =  plot(tr2u(:,2),1./tr2u(:,1),'b-.');
%set(pl,'LineWidth',2.0)
%pl =  plot(tr2l(:,2),1./tr2l(:,1),'g-.');
%set(pl,'LineWidth',2.0)
grid
%set(pl,'LineWidth',2.0)
set(gca,'box','on',...
    'SortMethod','childorder','TickDir','out','FontWeight',...
    'bold','FontSize',fontsz.m,'Linewidth',1.,'Ticklength',[0.02 0.02])
xlabel('Magnitude ')
set(gca,'Yscale','log');
ylabel('Annual Probability ')

matdraw

set(gcf,'color','w');set(gca,'color','w');