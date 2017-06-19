report_this_filefun(mfilename('fullpath'));

%

var1 = zeros(1,ncu);
var2 = zeros(1,ncu);
as = zeros(1,ncu);

%calculate as
%
mean1 = mean(cumuall(1:it,:));
mean2 = mean(cumuall(it:len,:));

for i = 1:ncu
    var1(i) = cov(cumuall(1:it,i));
end     % for i

for i = 1:ncu
    var2(i) = cov(cumuall(it:len,i));
end     % for i

as = (mean1 - mean2)./(sqrt(var1/it+var2/(len-it)));

re3 = reshape(as,length(gy),length(gx));

ma = [ma max(max(re3))];
mi = [mi min(min(re3))];

