report_this_filefun(mfilename('fullpath'));

% compute the mean depth along a x-section


button = questdlg('Mean Depth Computation','Which method would you like?','Constant number steps','Constant km steps','yep');


switch button
    case 'Constant number steps'



        def = {'50','10'};
        ni2 = inputdlg({'Average over how many events in each step?','Move window by how many events?'},'Mean depth computation',1,def);
        l = ni2{1};
        xstep = str2double(l);
        l = ni2{2};
        movew = str2double(l);

        col = length(newa(1,:));
        [s,is] = sort(newa(:,col));
        newa = newa(is(:,1),:) ;

        d= newa(:,col);
        z =-newa(:,7);

        MD = [];
        for i= 1:movew:length(d)-xstep
            MD = [MD ; mean(z(i:i+xstep)) mean(d(i:i+xstep)) std(z(i:i+xstep))];
        end

    case 'Constant km steps'

        def = {'50','10'};
        ni2 = inputdlg({'Step width in km?','step size in [km]'},'Mean depth computation',1,def);
        l = ni2{1};
        xstep = str2double(l);
        l = ni2{2};
        movew = str2double(l);

        [s,is] = sort(newa(:,10));
        newa = newa(is(:,1),:) ;

        col = length(newa(1,:));
        d= newa(:,col);
        z =-newa(:,7);

        MD = [];
        for i= 0:movew:max(d)-xstep
            l = d >= i & d < i+xstep;
            MD = [MD ; mean(z(l)) mean(d(l)) std(z(l))];
        end

end % switch


figure
plot(d,z,'.r','markersize',1);
hold on
errorbar(MD(:,2),MD(:,1),MD(:,1)+MD(:,3));

pl = plot(MD(:,2),MD(:,1),'sk');

axis([min(d) max(d) min(z) max(z)]);
xlabel('Distance [km]')
ylabel('Depth [km]');
matdraw





