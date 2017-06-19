% This is recperc
% A file to count the number of noder below a certain
% recurrence time value and divede by the total nu,ber of nodes;

% Stefan Wiemer 02/99

report_this_filefun(mfilename('fullpath'));

l = isnan(re4);
rt = re4;
rt(l) = [];
le = length(rt); pe = [];

for i = min(rt) : min(rt)/10: min(rt)*10;
    l = rt <= i;
    pe = [pe ; length(rt(l))/le*100 i];
end

figure
plot(pe(:,2),pe(:,1));
hold on
plot(pe(:,2),pe(:,1),'sr');
set(gca,'pos',[0.2 0.2 0.6 0.6])



set(gca,'visible','on','FontSize',fontsz.m,'FontWeight','bold',...
    'LineWidth',1.2,'Box','on','TickDir','out')
xlabel('Tr [years]','FontWeight','bold','FontSize',fontsz.m)
ylabel('Percentage (T >= Tr)','FontWeight','bold','FontSize',fontsz.m)

; matdraw