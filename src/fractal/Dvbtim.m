%
% This code creates the plot of the D-value versus the b-value. Calculates the
% standard deviation represented by the green lines.
% The code is called from fdtime.m.
% Francesco Pacchiani 3/2000
%
%
[b2, ord] = sort(bv2(:,1));
fdtim1 = fdtim2(ord,1);
bx = [b2(1):0.05:b2(end)]';
Dy = 2*bx;
clear ord;

figure_w_normalized_uicontrolunits('Numbertitle','off','Name','D versus b (blue line: D = 2b)', 'position', [490 150 400 350]);
plot(bv2(:,1),fdtim2(:,1),'ko','Markersize', 8);
hold on;
plot(bx, Dy, 'b-');
xlabel('b-value', 'fontsize', 12);
ylabel('D-value', 'fontsize', 12);
title('D-value versus b-value', 'fontsize', 14);
%
%
% Least squares regression of the points.
%
reg = [ones(size(fdtim2,1),1), bv2(:,1)];
[sl, cint, res, resint, stat] = regress(fdtim2(:,1), reg, 0.666);

sl
stat

rsl = [sl(2,1) sl(1,1)];
coef1 = [cint(2,1), cint(1,1)];
coef2 = [cint(2,2), cint(1,2)];
deltar = sl(2,1) - cint(2,1);
[line] = polyval(rsl,bx);
[line1] = polyval(coef1, bx);
[line2] = polyval(coef2, bx);

hold on;
plot(bx, line, 'r', 'Linewidth', 1.5);
plot(bx, line1, 'g');
plot(bx, line2, 'g');

clear reg, sl, stat, res, resint, cint, rsl, coef1, coef2, deltar, line, line1, line2;
%
%
% Text
%
str2 = ['D = xb: x =  ' sprintf('%.2f',sl(2,1)) '  +/- ' sprintf('%.2f', deltar)];
axes('pos',[0 0 1 1]); axis off; hold on;
te1 = text(0.15, 0.85, str2,'Fontweight','bold', 'fontsize', 10);