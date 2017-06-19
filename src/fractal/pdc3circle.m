%
% This code calculates the interevent distances and the correlation integral
% of a given earthquake distribution. The code is called from circlefd.m.
% Francesco Pacchiani 1/2000
%
%
% Calculation of the 3D distances between all possible pairs
% (combination of n epicenters taken 2 at a time) of earthquakes of
% the given dataset.
%
%
% Variables
%
N = size(E,1);				% N= # of events in the catalogue; E= Earthquake catalogue
pairdist = []; 			% pairdist= Vector of interevent distances
j = nchoosek(N,2);			% j= # of interevent distances calculated
pairdist = zeros(j,1);
depth = zeros(j,1);
k = 0;
%E(:,2)= (max(Da(:,2))+min(Da(:,2)))/2;


Ho_Wb = waitbar(0,'Calculating the fractal dimension D');
Hf_Cfig = gcf;
Hf_child = get(groot,'children');
set(Hf_child,'pointer','watch','papertype','A4');
%
%
% Calculation of the interevent distances in 2D plus the depths differences.
%
%
for i = 1:(N-1)

    lon1 = repmat(E(i,1), [(N-i),1]);
    lat1 = repmat(E(i,2), [(N-i),1]);
    depth1 = repmat(E(i,7), [(N-i),1]);

    lon2 = E((i+1):end, 1);
    lat2 = E((i+1):end, 2);
    depth2 = E((i+1):end, 7);

    pairdist(k+1:k + size(lon1, 1)) = distance(lat1,lon1,lat2,lon2);
    depth(k+1:k + size(lon1, 1)) = depth1-depth2;

    k = k + size(lon1,1);

    waitbar((0.75/(N-1))*i, Ho_Wb);

end

clear i j k;
%
%
% Conversion of the interevent distances from degrees to kilometers and calculates
% the interevent distances in three dimensions.
%
%
if dtokm == 1
    pairdist = pairdist.*111;
end

pairdist = (pairdist.^2 + depth.^2).^0.5;		% pairdist = Interevent distances (vector).
clear depth;
%
%
% Calculation of the correlation integral using as input the
% pair distances computed above.
%
%
% Variables
%
d = 3;						%d = the dimension of the embedding volume.
rmax = max(pairdist);
rmin = min(pairdist);

if rmin == 0
    rmin = 0.005;
end


%rinc = round((rmax-rmin)/0.43);
lrmin = log10(rmin);
lrmax = log10(max(pairdist));
r = (logspace(lrmin, lrmax, 50))';
%
%
corint = [];						% corint= Vector of correlation integral values for increasing distance
corint = zeros(size(r,1),1);
k = 1;

for i = 1:size(r,1)

    j = [];
    j = pairdist < r(i);
    corint (k,1) = (2/(N*(N-1)))*sum(j);
    k = k + 1;
    waitbar(0.75 + (0.25/size(r,1))*i,Ho_Wb);

end

clear i j k;
close(Ho_Wb);
Hf_child = get(groot,'children');
set(Hf_child,'pointer','arrow');
%
%
dofd = 'fd';