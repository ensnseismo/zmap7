% Creates the plot showing the variation of the two-by-two slope of the
% correlation integral versus the logarithmic distance.
%
% Francesco Pacchiani 1/2000
%
%
HfigS = figure_w_normalized_uicontrolunits('Numbertitle', 'off', 'Name', 'Slope');
Hl1 = semilogx(r2,deriv(:,1), 'Marker','o', 'Markersize',10, 'color','k' );
set(gca, 'position', [0.12 0.15 0.8 0.75], 'fontsize', 10);%'fontweight', 'bold', );
title('The First Derivative of the Correlation Integral', 'fontsize', 14);
xlabel('Distance [km]', 'fontsize', 12);
ylabel('Slope', 'fontsize', 12);

ri = find(r2 >= rad & r2 < ras);
r5 = r2(ri(1:end-1));
deriv5 = deriv(ri(1:end-1));
figure_w_normalized_uicontrolunits(HfigS);
hold on;
semilogx(r5,deriv5(:,1), 'linewidth',3, 'color','r');
axis([0.0005 10000 0 5]);
axes('pos',[0 0 1 1]); axis off; hold on;
str1 = ['D-value = ' sprintf('%.2f',coef(1,1)) ' +/- ' sprintf('%.2f', deltar)];
te3 = text(0.60, 0.85, str1, 'fontsize', 12);
%clear deriv5 r5 ri


%deriv1 = [];

%for nd = 1:size(deriv,1)-2
%
%   if deriv(nd)>0 & deriv(nd+1)>0
%      dif = abs(deriv(nd+1) - deriv(nd));
%
%      if dif <= 0.3
%         moy = (deriv(nd+1) + deriv(nd))/2;
%         vars = ((deriv(nd+2)-moy).^2)*1/2;
%
%         if vars <= 0.004
%
%            deriv1 = [deriv1; nd; nd+1; nd+2];
%            deriv2 = unique(deriv1, 'rows');
%
%moy1 = moy + deriv(nd+2);
%vars = ((deriv(nd+2)-moy).^2)*1/2;


%vars = sum(var251, 2)*1/25
%stdev25 = var25.^(1/2);
%if abs(deriv(nd+2)-moy) <= 0.05

%end
%         end
%      end
%   end
%end

%for nd1 = 1:size(deriv2,1);

%   if deriv2(nd1+1)=deriv2(nd)+1
%      si(nd1)=

%rad = r2(deriv2(1))
%ras = r2(deriv2(end))
%
%figure_w_normalized_uicontrolunits(HfigS);
%hold on;
%rect = [0.15 0.10 0.7 0.30];
%axes('position', rect, 'Xtick', [0.01 100], 'Ytick', [0 10]);
%Hl1 = semilogx(r2,deriv(:,1), 'Marker','o','Markersize',4, 'color', 'k' );
%title('The slope calculated for each two consecutive points of the Correlation Integral Plot');
%xlabel('Log(Distance)');
%ylabel('Slope');

%r5 = r2(deriv2);
%deriv5 = deriv(deriv2);
%figure_w_normalized_uicontrolunits(HfigS);
%hold on;
%semilogx(r5,deriv5(:,1), 'r');
%clear deriv5 r5 nd nd1 moy vars deriv1 deriv2
