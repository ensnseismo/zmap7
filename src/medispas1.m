%  This is subroutine " medispas1.m". A as(t) value is calculated for
%  a given mean depth  curve and displayed in the plot.
%  Overlapping mean depth windows are avoided
%  Operates on catalogue newcat                          A.Allmann

report_this_filefun(mfilename('fullpath'));

%
% start and end time
%
%b = newcat;
%select big evenets
%l = b(:,6) > minmag;
%big = b(l,:);


%
%  iwl is the cutoff at the beginning and end of the analyses
%  to afoid spikes at the end
%iwl = 5;


%
% calculate mean and z value
%
ncu = length(xt2);    %number of all mean depth windows
af = iwln/step;     %to avoid resampling because of overlapping windows
m = 0;            %counter of independent mean depth windows without iwl
as = [];
xt3 = [];

% calculation of the as values and attached times
%
if sta == 'ast'
    for i = 1+iwl*af:af:ind-iwl*af
        mean1 = mean(meand(1:af:i));
        mean2 = mean(meand(i:af:ncu));
        var1 = cov(meand(1:af:i));
        var2 = cov(meand(i:af:ncu));
        m = m+1;
        as(m) = (mean1 - mean2)/sqrt(var1/(1+fix(i*(step/iwln)))+...
            var2/fix((ncu-i)*(step/iwln)));
        xt3(m) = xt2(i);
    end     % for i
end     % if sta

if sta == 'lta'
    for i = 1+iwl*af:af:ind-iwl*af
        mean1 = mean(meand(1:af:ncu));
        mean2 = mean(meand(i:af:i+iwl));
        var1 = cov(meand(1:af:ncu));
        var2 = cov(meand(i:af:i+iwl));
        m = m+1;
        as(m) = (mean1 - mean2)/sqrt(var1/length(meand(1:af:ncu)) +...
            var2/length(i:af:i+iwln));
        xt3(m) = xt2(i);
    end     % for i
end % if sta == lta


%
%  Plot the as(t)
%
%figure_w_normalized_uicontrolunits(2)

try
    delete(p5)
    delete(ax1)
catch ME
    error_handler(ME, @do_nothing);
end
figure
orient tall
rect = [0.15, 0.10, 0.65, 0.30];
axes('position',rect)
p5 = gca;

plot(xt3,as,'r')

%set(ax1,'FontSize',fontsz.m,'FontWeight','bold')
%set(ax2(1),'LineWidth',2.0)
%set(ax2(2),'LineWidth',1.0)


xlabel('Time  [years]')
ylabel('Mean Depth (km)')
%set(pyy1,'FontWeight','bold')
%set(pyy1,'Position',[1.1 0.5 0])

stri = ['Mean depth and z-value of ' file1];
title(stri)
grid

%hold on;

% plot big events on curve
%
%if ~isempty(big)
% f = cumu2((big(:,3) -t0b)*365/par1);
% bigplo = plot(big(:,3),f,'xb');
% set(bigplo,'MarkerSize',10,'LineWidth',2.5)
% stri2 = [];
% [le1,le2] = size(big);
% for i = 1:le1;
%  s = sprintf('|  M=%3.1f',big(i,6));
%  stri2 = [stri2 ; s];
% end   % for i
% te1 = text(big(:,3),f,stri2);
% set(te1,'FontWeight','bold','Color','m','FontSize',12)
% end % if big