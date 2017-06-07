% Function to plot the zmax distribution

report_this_filefun(mfilename('fullpath'));

if exist('con') == 0 ; con = 1; end%

% First lets load the data
[file1,path1] = uigetfile(['*.mat'],'Zmax Data File Name?');

if length(path1) > 1
    think
    load([path1 file1])
else
    return
end

% Now lets plot the data
figure
histogram(pmib,min(pmib):.2:max(pmib))
set(gca,'box','on',...
    'SortMethod','childorder','TickDir','in','FontWeight',...
    'normal','FontSize',10,'Linewidth',1.2)
ti = get(gca,'TickLength');
set(gca,'TickLength',ti*2);
grid
xlabel('Zmax')
ylabel('Number ')
clear title
title(['N =' num2str(ni) ', #samples = ' num2str(n0) ', #repeats = ' num2str(nr*con) ', Tw= ' num2str(iwl0)]) ;


matdraw


% Now lets plot a Normal distribution on top
disp('Plotting normal distribution for comparison....')
n = normrnd(mean(pmib),std(pmib),length(pmib)*200,1);
hold on
[n1,x1] = hist(n,(-15:0.1:15));
set(gca,'XLim',[min(pmib) max(pmib)])
plot(x1,n1/200,'r')

p95 = prctile2(n,1)
p99 = prctile2(n,5)
p50 = prctile2(n,50)
te = text(0.6,0.8,['  1 percentile: ' num2str(p99,3)],'Units','normalized');
te = text(0.6,0.85,['  5 percentile: ' num2str(p95,3)],'Units','normalized');
te = text(0.6,0.9,['  50 percentile: ' num2str(p50,3)],'Units','normalized');
%te = text(0.6,0.75,['  Max : ' num2str(pma)],'Units','normalized');
%te = text(0.6,0.70,['  Min : ' num2str(pmi)],'Units','normalized');
%te = text(0.6,0.65,['  STD : ' num2str(si)],'Units','normalized');

clear n
