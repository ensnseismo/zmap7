%
% This algorithm constructs a 3-dimensional Sierpinski Gasket using the chaos game method.
% Called from dorand.m.
% Francesco Pacchiani 8/2000.
%
%
p1 = [0 0 0];
p2 = [1 0 0];
p3 = [0.5 0.866 0];
p4 = [0.5 0.433 0.75];
z = [rand(1,1) rand(1,1) rand(1,1)];
Sier = [];
Sier = zeros(numran,3);
Sier(1,:) = z;

for k = 2:numran
    n = ceil(rand(1,1)*4);

    if n == 1
        p = p1;
    elseif n == 2
        p = p2;
    elseif n == 3
        p = p3;
    elseif n == 4
        p = p4;
    end %if n

    z = [z(1,1)*0.5 + p(1,1)*0.5, z(1,2)*0.5 + p(1,2)*0.5, z(1,3)*0.5 + p(1,3)*0.5];
    Sier(k,[1 2 3]) = z;

end %for k


Sier = Sier(16:numran,:);
Sier = [Sier(:,1)*long + long1 Sier(:,2)*lati + lati1 Sier(:,3)*dept];
ranp = [Sier(:,1) Sier(:,2) -Sier(:,3)];
E = [Sier(:,1) Sier(:,2) zeros(size(Sier,1),1) zeros(size(Sier,1),1) zeros(size(Sier,1),1) zeros(size(Sier,1),1) Sier(:,3)];
ran = E;

clear k n z p1 p2 p3 p4 Sier