report_this_filefun(mfilename('fullpath'));
%

lta = 1:1:ncu-2;
var1 = zeros(1,ncu);
var2 = zeros(1,ncu);
lta = zeros(1,ncu);
maxlta = zeros(1,ncu);
maxlta = maxlta -5;

mean1 = mean(cumuall(1:len,:));
mean2 = mean(cumuall(it:it+iwl,:));
it

for i = 1:ncu
    var1(i) = cov(cumuall(1:len,i));
end     % for i


for i = 1:ncu
    var2(i) = cov(cumuall(it:it+iwl,i));
end     % for i

lta = (mean1 - mean2)./(sqrt(var1/len+var2/(iwl)));

re3 = reshape(lta,length(gy),length(gx));

ma = [ma max(max(re3))];
mi = [mi min(min(re3))];


