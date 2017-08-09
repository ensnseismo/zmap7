report_this_filefun(mfilename('fullpath'));

var1 = zeros(1,ncu);
var2 = zeros(1,ncu);
lta = zeros(1,ncu);
maxlta = zeros(1,ncu);
maxlta = maxlta -5;

cu = [cumuall(1:ti-1,:) ; cumuall(ti+iwl+1:len,:)];
mean1 = mean(cu(:,:));
mean2 = mean(cumuall(it:it+iwl,:));
it

for i = 1:ncu
    var1(i) = cov(cu(:,i));
end     % for i

for i = 1:ncu
    var2(i) = cov(cumuall(it:it+iwl,i));
end     % for i

lta = (mean1 - mean2)./(sqrt(var1/(len-iwl)+var2/(iwl)));
re3 = reshape(lta,length(gy),length(gx));



% define size of the plot etc.
%
% set values gretaer tresh = nan
%
%[len, ncu] = size(cumuall);
s = cumuall(len,:);
r = reshape(s,length(gy),length(gx));
l = r > tresh;
re4 = re3;
re4(l) = zeros(1,length(find(l)))*nan;

figure_w_normalized_uicontrolunits(tmp)
clf reset
rect = [0.10 0.30 0.55 0.50 ];
rect1 = rect;

% find max and min of data for automatic scaling
%


% plot image
%
orient landscape
axes('position',rect)
pco1 = pcolor(gx,gy,re4);
shading interp
caxis([minc maxc]);
colormap(jet)
hold on
% plot overlay
%
overlay


tx2 = text(0.07,0.85 ,['ti=' num2str(it*days(ZG.bin_days)+t0b)  ] ,...
    'Units','Norm','FontSize',14,'Color','k','FontWeight','bold');


tx = text(0.07,0.95 ,['LTA;' num2str(iwl3) ' years' ] ,...
    'Units','Norm','FontSize',14,'Color','k','FontWeight','bold');


has = gca;


