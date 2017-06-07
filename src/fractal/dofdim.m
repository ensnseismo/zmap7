%
% This code calculates the correlation dimension which is the slope on the
% log-log graph and plots it as a line. The confidence interval is also
% calculated and plotted.
% This code is called from either pdc2.m or pdc3.m.
% Francesco Pacchiani 1/2000
%
%
deriv = diff(log10(corint),1,1)./diff(log10(r),1,1);			% deriv= Vector of the appr. derivatives
r2 = r(1:(end-1));	% Forward difference approximation: deriv has one element less, and r must have the # of elements so r2

switch(dofd)

    case 'fd'

        %
        % Calculation of the correlation dimension, by first calculating the
        % distances of depopulation "rad" and of saturation "ras". Manually chosen
        % they are named: radm and rasm.
        %
        if exist('radm') == 0 ; radm = []; end
        if exist('rasm') == 0 ; rasm = []; end

        if isempty(radm)  &&  isempty(rasm);

            rad = (rmax*((1/size(E,1))^(1/d)))/3;		% 2rmax= linear size of the hypercube enclosing a given dataset
            ras = rmax/(2*(d+1));
        else

            rad = radm;
            ras = rasm;

        end

        v = find(r2 >= rad & r2 <= ras);	% v= Vector of the all the interevent distances that fall in the interval [rn,rs]
        lr = log10(r2(v));
        lc = log10(corint(v));
        r3 = r2(7:end,1);

        [coef, Err] = polyfit(lr,lc,1);
        [line, delta] = polyval(coef, log10(r3), Err);

        rlc = lc(end:-1:1);
        rlr = lr(end:-1:1);
        reg = [ones(size(v,1),1),lr];

        [sl, cint, res, resint, stat] = regress(lc, reg, 0.66);
        sl
        stat;

        coef1 = [cint(2,1), cint(1,1)];
        coef2 = [cint(2,2), cint(1,2)];
        [line1] = polyval(coef1, log10(r3));
        [line2] = polyval(coef2, log10(r3));

        deltar = sl(2,1) - cint(2,1);
        if deltar < 0.01

            deltar = 0.01;
        end

        Ha_Cax = gca;
        axis([0.00001 100 0.00001 10]);
        figure_w_normalized_uicontrolunits(Hf_Fig);
        hold on;
        Hl_gr2a = loglog(r2(v), corint(v), 'r.');
        set(Hl_gr2a,'MarkerSize',20);
        hold on;
        Hl_gr2b = plot(r3,10.^line,'b','Linewidth',2);
        Hl_gr2d = plot(r3, 10.^line1,'g', 'Linewidth', [0.5]);
        Hl_gr2e = plot(r3, 10.^line2, 'g', 'Linewidth',0.5);
        set(Ha_Cax,'pos',[0.15 0.13 0.76 0.70], 'fontsize', 11);


        uicontrol('Units','normal','Position',[.0 .92 .15 .07],...
            'String','Scaling range', 'Callback','g = ginput(2);dofd = ''newrange''; dofdim');

        uicontrol('Units','normal','Position',[.155 .92 .15 .07],...
            'String','Slope test', 'Callback','slopetest');

        uicontrol('Units','normal','Position',[.31 .92 .15 .07],...
            'String','MLE', 'Callback',' taken;');


        str1 = ['Range = [' sprintf('%.2f',rad) '; ' sprintf('%.2f',ras) ']'];
        str2 = ['D =  ' sprintf('%.2f',coef(1,1)) '  +/- ' sprintf('%.2f', deltar)];
        axes('pos',[0 0 1 1]); axis off; hold on;
        te1 = text(0.18, 0.78, str1, 'fontsize', 12);
        te2 = text(0.18, 0.73, str2, 'fontsize', 12);

        if exist('sph') == 1
            str7 = [sprintf('%.0f', size(E,1)) ' points in the sphere.'];
            te7 = text(0.25, 0.7, str7, 'Fontweight','bold');
        else
            str7 = [];
        end

        %clear reg sl stat cint res resint rsl coef1 coef2 line line1 line2;


    case 'newrange'

        v = [];lr =[]; lc =[];
        rad = min(g(:,1));
        ras = max(g(:,1));
        v = find(r2 >= rad & r2 <= ras);
        r3 = r(7:end,1);%(7:v(end)+10,1);

        lr = log10(r2(v));
        lc = log10(corint(v));

        [coef, Err] = polyfit(lr,lc,1);
        [line, delta] = polyval(coef, log10(r3), Err);

        rlc = lc(end:-1:1);
        rlr = lr(end:-1:1);
        reg = [ones(size(v,1),1),lr];

        [sl, cint, res, resint, stat] = regress(lc, reg, 0.66);
        sl
        stat;

        coef1 = [cint(2,1), cint(1,1)];
        coef2 = [cint(2,2), cint(1,2)];
        [line1] = polyval(coef1, log10(r3));
        [line2] = polyval(coef2, log10(r3));

        deltar = sl(2,1) - cint(2,1);
        if deltar < 0.01
            deltar = 0.01;
        end


        figure_w_normalized_uicontrolunits(Hf_Fig);
        set(Hl_gr2a, 'Xdata', r2(v), 'Ydata', corint(v));
        set(Hl_gr2b, 'Xdata', r3, 'Ydata', 10.^line);
        set(Hl_gr2d, 'Xdata', r3, 'Ydata', 10.^line1);
        set(Hl_gr2e, 'Xdata', r3, 'Ydata', 10.^line2);



        str1 = ['Range = [' sprintf('%.2f',rad) '; ' sprintf('%.2f',ras) ']'];
        str2 = ['D =  ' sprintf('%.2f',coef(1,1)) '  +/- ' sprintf('%.2f', deltar)];
        axes('pos',[0 0 1 1]); axis off; hold on;
        set(te1, 'string', str1);
        set(te2, 'string', str2);

        %clear reg sl stat cint res resint rsl coef1 coef2 line line1 line2;

        g = [];
        uicontrol('Units','normal','Position',[.0 .92 .15 .07],...
            'String','Scaling range', 'Callback','g = ginput(2);dofd = ''newrange''; dofdim')

        uicontrol('Units','normal','Position',[.16 .92 .15 .07],...
            'String','Slopetest', 'Callback','slopetest');

        % uicontrol('Units','normal','Position',[.31 .92 .15 .07],...
        %    'String','MLE', 'Callback',' taken;');


end
