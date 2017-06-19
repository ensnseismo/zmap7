% Compare is used to compare the significance of two segments
% in the plot of cumulative misfit as a function of earthquake number.
%  --- Zhong Lu, June 1994.
%

report_this_filefun(mfilename('fullpath'));

dat(:,2)=mi2(:,2);
dat(:,1)=[1:length(mi2(:,1))]';
cumu = dat(:,2);
xt = dat(:,1);
cumu2 = cumsum(cumu);

hold on;
par1 = 0.5;
par2 = 1.0;
choice = input('type 1 to select range with cursor, 2 to input event numbers  ');
if choice == 1
    t1 = [];
    t1 = ginput(1);
    t1(1)=round(t1(1));
    t1p = [  t1 ; t1(1) t1(2)-par1];
    plot(t1p(:,1),t1p(:,2),'r');
    text( t1(1),t1(2)-par2,['t1: ', num2str(t1p(1))] );

    t2 = [];
    t2 = ginput(1);
    t2(1)=round(t2(1));
    t2p = [  t2 ; t2(1) t2(2)-par1];
    plot(t2p(:,1),t2p(:,2),'r');
    text( t2(1),t2(2)-par2,['t2: ', num2str(t2p(1))] );

    t3 = [];
    t3 = ginput(1);
    t3(1)=round(t3(1));
    t3p = [  t3 ; t3(1) t3(2)+par1];
    plot(t3p(:,1),t3p(:,2),'r');
    text( t3(1),t3(2)+par2,['t3: ', num2str(t3p(1))] );

    t4 = [];
    t4 = ginput(1);
    t4(1)=round(t4(1));
    t4p = [  t4 ; t4(1) t4(2)+par1];
    plot(t4p(:,1),t4p(:,2),'r');
    text( t4(1),t4(2)+par2,['t4: ', num2str(t4p(1))] );
else
    %tmp = 't1(1),t2(1),t3(1),t4(1)';
    t1(1) = str2double(input('type the 1st event number, then return    ','s'));
    t2(1) = str2double(input('type the 2nd event number, then return    ','s'));
    t3(1) = str2double(input('type the 3rd event number, then return    ','s'));
    t4(1) = str2double(input('type the last event number, then return    ','s'));
end  % if
hold on;

mean1 = mean(cumu(t1(1):t2(1)));
mean2 = mean(cumu(t3(1):t4(1)));
var1  = cov(cumu(t1(1):t2(1)));
var2  = cov(cumu(t3(1):t4(1)));
zvalue = (mean1 - mean2)/(sqrt(var1/(t2(1)-t1(1)+1)+var2/(t4(1)-t3(1)+1)))

if abs(zvalue) >= 2.58 %99%
    S = sprintf('Significant at 99%% ');
    disp(S);
elseif abs(zvalue) >= 1.96 %95%
    S = sprintf('Significant at 95%% ');
    disp(S);
elseif abs(zvalue) >= 1.64 %90%
    S = sprintf('Significant at 90%% ');
    disp(S);
elseif abs(zvalue) >= 1.44 %85%
    S = sprintf('Significant at 85%% ');
    disp(S);
else
    S = sprintf('May Significant below 85%% ');
    disp(S);
end % if

% use the t-test
tvalue=(mean1 - mean2) * sqrt(t2(1)-t1(1)+t4(1)-t3(1)) / sqrt((t2(1)-t1(1)) * var1+(t4(1)-t3(1))*var2) / sqrt(1.0/(t2(1)-t1(1)+1)+1.0/(t4(1)-t3(1)+1))

N=t2(1)-t1(1)+t4(1)-t3(1)
disp('N=n1+n2-2');

