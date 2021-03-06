CalcMonteGKWinParms.m%%%%%%%%%%%%%%%%%%
%   0000644 0001751 0000764 00000002226 10353232507 015623  0%%%%%%%%%%%%%%%%%%%%%%
%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%function [fSpace, fTime] = CalcMonteGKWinParms(fMagnitude)

rng('shuffle');
mRndFactors_=rand(2,1);
%disp('Using Gruenthal, pers. communication')
fSpace1 = 10.^(0.1238*fMagnitude+0.983);
if fMagnitude >= 6.5
    fTime1 = (10.^(0.032*fMagnitude+2.7389))/365;
else
    fTime1 = (10.^(0.5409*fMagnitude-0.547))/365;
end

%disp('Using Gruenthal, pers. communication')
fSpace2 = exp(1.77+sqrt(0.037+1.02*fMagnitude));
if fMagnitude < 6.5
    fTime2 = abs((exp(-3.95+sqrt(0.62+17.32*fMagnitude)))/365);
else
    fTime2 = (10.^(2.8+0.024*fMagnitude))/365;
end
%disp('Urhammer, 1976');
fSpace3 = exp(-1.024+0.804*fMagnitude);
fTime3 = (exp(-2.87+1.235*fMagnitude))/365;

fSpaceMin = min([fSpace1,fSpace2,fSpace3]);
fSpaceMax = max([fSpace1,fSpace2,fSpace3]);
fSpaceRange = [min(fSpaceMin) max(fSpaceMax)];
% chose randomly value out of fSpaceRange
fSpace=mRndFactors_(1)*(max(fSpaceRange)-min(fSpaceRange))+min(fSpaceRange);

fTimeMin = min([fTime1,fTime2,fTime3]);
fTimeMax = max([fTime1,fTime2,fTime3]);

fTimeRange = [min(fTimeMin) max(fTimeMax)];
% chose randomly value out of fTimeRange
fTime=mRndFactors_(2)*(max(fTimeRange)-min(fTimeRange))+min(fTimeRange);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  CalcMonteGKWinParms.m~%%%%%%%%%%%%%%%
%%%%  0000644 0001751 0000764 00000002171 10353232353 016017  0%%%%%%%%%%%%%
%%%%%%%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%function [fSpaceRange, fTimeRange] = CalcMonteGKWinParms(fMagnitude)

rng('shuffle');
mRndFactors_=rand(2,1)
%disp('Using Gruenthal, pers. communication')
fSpace1 = 10.^(0.1238*fMagnitude+0.983);
if fMagnitude >= 6.5
    fTime1 = (10.^(0.032*fMagnitude+2.7389))/365;
else
    fTime1 = (10.^(0.5409*fMagnitude-0.547))/365;
end

%disp('Using Gruenthal, pers. communication')
fSpace2 = exp(1.77+sqrt(0.037+1.02*fMagnitude));
if fMagnitude < 6.5
    fTime2 = abs((exp(-3.95+sqrt(0.62+17.32*fMagnitude)))/365);
else
    fTime2 = (10.^(2.8+0.024*fMagnitude))/365;
end
%disp('Urhammer, 1976');
fSpace3 = exp(-1.024+0.804*fMagnitude);
fTime3 = (exp(-2.87+1.235*fMagnitude))/365;

fSpaceMin = min([fSpace1,fSpace2,fSpace3]);
fSpaceMax = max([fSpace1,fSpace2,fSpace3]);
fSpaceRange = [min(fSpaceMin) max(fSpaceMax)];
% chose randomly value out of fSpaceRange
fSpace=mRndFactors_(1)*(max(fSpaceRange)-min(fSpaceRange))+min(fSpaceRange);

fTimeMin = min([fTime1,fTime2,fTime3]);
fTimeMax = max([fTime1,fTime2,fTime3]);

fTimeRange = [min(fTimeMin) max(fTimeMax)];
ftime=mRndFactors_(1)*(max(fSpaceRange)-min(fSpaceRange))+min(fSpaceRange);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%   CVS/%%%%%%%%%%%%%%%%%%%%%%%%0000755 0001751 0000764 00000000000 10400621312 012313  5%%%
%%%%%%%%%%%%%%%%%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%CVS/Root%%%%%%%%%%%%
%%%%%%%%%%%0000644 0001751 0000764 00000000062 10400621311 013156  0%%%%%%%%
%%%%%%%%%%%%%%%%%ustar   thomas%%%%
%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%:pserver:thomas@datacentral.ethz.ch:/home/cvsroot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%  CVS/Repository%%%%%%%%%%%%%%%%%
%%%%  0000644 0001751 0000764 00000000034 10400621311 014411  0%%%%%%%%%%%%%%%%%%%%
%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%zmap/src/thomas/montereason
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CVS/Entries%%%%%%%%%%%%%%%%%%
%%%% 0000644 0001751 0000764 00000000002 10400621311 013636  0%%%%%%%%%%%
%%%%%%%%%%%%%%ustar thomas%%
%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  CVS/Template%%%%%%%%%%%%%%%%%%
%%%%0000644 0001751 0000764 00000000000 10400625051 014003  0%%%%%%%%%%%%%%%%%%%
%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%FindDecLoc.m%%%%%%%%%%%%%%%%%
%%%%%0000644 0001751 0000764 00000001461 10347520376 014014  0%%%%%%%%%%%%%%
%%%%%%%%%%%ustar   thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function[depCat,indCat] = FindDecLoc();


load /Users/matt/MonteDeclus/results/DeclusResRfact.mat

[lCat, numCats] = size(decResult);

countCat = zeros(1,10);

for catLoop = 1:numCats
    decCat = decResult{catLoop};
    is5 = decCat(:,6) >= 5;
    decCat = decCat(is5,:);
    [lDC wDC] = size(decCat);
    for cLoop = 1:lDC
        isIn = decCat(cLoop,1) == countCat(:,1) & decCat(cLoop,2) == countCat(:,2) & decCat(cLoop,3) == countCat(:,3);
        %isIn = decCat(cLoop,:) == countCat(:,:);
        if sum(isIn) > 0
            countCat(isIn,10) = countCat(isIn,10) + 1;
        else
            dCat = [decCat(cLoop,:) 1];
            countCat = [countCat;dCat];
        end
    end
end

independent = countCat(:,10) == numCats;
indCat = (countCat(independent,:));
countCat(independent,:) = [];
depCat = countCat;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   funBuildcat.m%%%%%%
%%%%%%%%%%%%%%%   0000644 0001751 0000764 00000001645 10347520376 014326  0%%%
%%%%%%%%%%%%%%%%%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%function [newt2,is_mainshock]=funBuildcat(newcat,clus,bg,bgevent) 
%buildcat.m                                A.Allmann
%builds declustered catalog with equivalent events
%
%Last modification 8/95
%global newcat equi clus eqtime bg original backequi bgevent


tm1=find(clus==0);    %elements which are not related to a cluster
tmpcat=[newcat(tm1,:);bgevent]; % builds catalog with biggest events instead

% I am not sure that this is right , may need 10 coloum
                                   %equivalent event
[tm2,i]=sort([tm1';bg']);  %i is the index vector to sort tmpcat

%elseif var1==2
%  if isempty(backequi)
%   tmpcat=[original(tm1,1:9);equi(:,1:9)];
%  else
%   tmpcat=[original(tm1,1:9);backequi(:,1:9)];
%  end
% [tm2,i]=sort(tmpcat(:,3));
%end

newt2=tmpcat(i,:);       %sorted catalog,ready to load in basic program

is_mainshock = [tm1';bg'];  %% contains indeces of all cluster mainshocks.  added  12/7/05




%%%%%%%%%%%%%%%%%%%%%%   funBuildclu.m%%%%%%%%%%%%%%%%%%%%%   0000644 0001751 0000764 00000002076 10347520376 014341  0%%%%%%%%%%%%%%%%%%%%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function[cluslength,bgevent,mbg,bg,clustnumbers] = funBuildclu(newcat,bgevent,clus,mbg,k1,bg)     
% buildclu.m                                 A.Allmann
% builds cluster out out of information stored in clus
% calculates also biggest event in a cluster
%
% Last modification 8/95

%global newcat bgevent clus mbg k1 clust clustnumbers cluslength bg
cluslength=[];
n=0;
k1=max(clus);
for j=1:k1                         %for all clusters
    cluslength(j)=length(find(clus==j));  %length of each clusters
end

tmp=find(cluslength);      %numbers of clusters that are not empty

% modified to aviod large matrix clust

%clust=zeros(max(cluslength),length(tmp));

%for j=tmp                    %for all not empty clusters
 %  n=n+1;
 %  clust(1:cluslength(j),n)=find(clus==j)'; %matrix which stores clusters
%end


%cluslength,bg,mbg only for events which are not zero
cluslength=cluslength(tmp);
bgevent=bgevent(tmp);
mbg=mbg(tmp);
bg=bgevent;
bgevent=newcat(bg,:); %biggest event in a cluster(if more than one,take first)

clustnumbers=(1:length(tmp));    %stores numbers of clusters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  funClustime.m%%%%%%%%%%%%%%%%%%%%%   0000644 0001751 0000764 00000003041 10347520376 014354  0%%%%%%%%%%%%%%%%%%%%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function eqtime = clustime(var1,newcat)
% These routine calculates the time in days of the eqs. in newcat relative
% to the year 1902
%clustime.m                                          A.Allmann
%Last change  6/95

%global newcat ttcat tmpcat
load day1902.mat      %days relative to 1902 stored in variable c

mday= [0,31,59,90,120,151,181,212,243,273,304,334]';%cumulative days in one year
mdayl=[0,31,60,91,121,152,182,213,244,274,305,335]'; %leapyear
eqtime=[];%time of eqs. calculated according routine
% if var1==2
%   newcat=ttcat;
% elseif var1==3
%  newcat=tmpcat;
% end

if max(newcat(:,3)) < 100
   eqtime = datenum(floor(newcat(:,3))+1900, newcat(:,4), newcat(:,5), newcat(:,8), newcat(:,9),newcat(:,9)*0)-datenum(1902,1,1);
else
   eqtime = datenum(floor(newcat(:,3)), newcat(:,4), newcat(:,5), newcat(:,8), newcat(:,9),newcat(:,9)*0)-datenum(1902,1,1);
end
return

 l =  find(rem(fix(newcat(:,3)),4)==0);     %leapyears
 if size(l,1) > 0
  if length(newcat(1,:))>=9
   eqtime(l)=mdayl(newcat(l,4),1)+(newcat(l,5)-1)+newcat(l,8)/24+newcat(l,9)/1440+...
        c(fix(newcat(l,3))-1,1);
  else
    eqtime(l)=mdayl(newcat(l,4),1)+(newcat(l,5)-1)+c(fix(newcat(l,3))-1,1);
  end
 end

 l =  find(rem(fix(newcat(:,3)),4)~=0);   %normal years
 if size(l,1) > 0
  if length(newcat(1,:))>=9
   eqtime(l)=mday(newcat(l,4),1)+(newcat(l,5)-1)+newcat(l,8)/24+newcat(l,9)/1440+...
        c(fix(newcat(l,3))-1,1);
  else
   eqtime(l)=mday(newcat(l,4),1)+(newcat(l,5)-1)+c(fix(newcat(l,3))-1,1);
  end
 end

 eqtime=eqtime';

 return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   funDistance.m%%%%%%%%%%%%%%%%%%%%%   0000644 0001751 0000764 00000003512 10347520376 014324  0%%%%%%%%%%%%%%%%%%%%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function [dist1, dist2] = funDistance(i,bgevent,ac,newcat,err,derr)
% distance.m                                          A.Allmann
% calculates the distance in [km] between two eqs
% precise version based on Raesenbergs Program
% the calculation is done simultaniously for the biggest event in the
% cluster and for the current event
% Last modification 6/95

%global newcat err derr


pi2 = 1.570796;
rad = 1.745329e-2;
flat= 0.993231;

alatr1=newcat(i,2)*rad;     %conversion from degrees to rad
alonr1=newcat(i,1)*rad;
alatr2=newcat(bgevent,2)*rad;
alonr2=newcat(bgevent,1)*rad;
blonr=newcat(ac,1)*rad;
blatr=newcat(ac,2)*rad;

tana(1)=flat*tan(alatr1);
tana(2)=flat*tan(alatr2);
geoa=atan(tana);
acol=pi2-geoa;
tanb=flat*tan(blatr);
geob=atan(tanb);
bcol=pi2-geob;
diflon(:,1)=blonr-alonr1;
diflon(:,2)=blonr-alonr2;
cosdel(:,1)=(sin(acol(1))*sin(bcol)).*cos(diflon(:,1))+(cos(acol(1))*cos(bcol));
cosdel(:,2)=(sin(acol(2))*sin(bcol)).*cos(diflon(:,2))+(cos(acol(2))*cos(bcol));
delr=acos(cosdel);
top=sin(diflon)';
den(1,:)=sin(acol(1))/tan(bcol)-(cos(acol(1))*cos(diflon(:,1)))';
den(2,:)=sin(acol(2))/tan(bcol)-(cos(acol(2))*cos(diflon(:,2)))';
azr=atan2(top,den);                   %azimuth to North
colat(:,1)=pi2-(alatr1+blatr)/2;
colat(:,2)=pi2-(alatr2+blatr)/2;
radius=6371.227*(1+(3.37853e-3)*(1/3-((cos(colat)).^2)));
r=delr.*radius;            %epicenter distance
r=r-1.5*err;               %influence of epicenter error
tmp1=find(r<0);
if ~isempty(tmp1)
  r(tmp1)=zeros(length(tmp1),1);
end
z(:,1)=abs(newcat(ac,7)-newcat(i,7));    %depth distance
z(:,2)=abs(newcat(ac,7)-newcat(bgevent,7));
z=z-derr;
tmp2=find(z<0);
if ~isempty(tmp2)
 z(tmp2)=zeros(length(tmp2),1);
end
r=sqrt(z.^2+r.^2);                   %hypocenter distance
%alpha=atan2(z,r);
%ca =cos(alpha);
%sa =sin(alpha);
dist1=r(:,1);           %distance between eqs
dist2=r(:,2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  funEquevent.m%%%%%%%%%%%%%%%%%%%%%   0000644 0001751 0000764 00000001534 10347520376 014370  0%%%%%%%%%%%%%%%%%%%%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function equi=equevent
%  equevent.m                                       A.Allmann
% calculats equivalent event to a cluster
% weight according to seismic moment
% time for equivalent event is time of first biggest event
%
% Last change 11/95
global clus newcat  cluslength bg clustnumbers

j=0;
eqmoment=10.^(newcat(:,6).*1.2);

for n=1:max(clus)
   l = clus == n;
   if max(l) >0;
      j = j + 1;
      emoment=sum(eqmoment(l));         %moment

      weight=eqmoment(l)./emoment;      %weightfactor
      elat(j)=sum(newcat(l,1).*weight); %latitude
      elon(j)=sum(newcat(l,2).*weight); %longitude
      edep(j)=sum(newcat(l,7).*weight); %depth
      emag(j)=(log10(emoment))/1.2;
   end

end


%equivalent events for each cluster
equi=[elat' elon' newcat(bg,3) newcat(bg,4) newcat(bg,5) emag' edep' newcat(bg,8) newcat(bg,9)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%funInteract.m%%%%%%%%%%%%%%%%%%%%%   0000644 0001751 0000764 00000001261 10347520376 014342  0%%%%%%%%%%%%%%%%%%%%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function [rmain,r1]= funInteract(var1,newcat,rfact,xmeff) 
%interact.m                                        A.Allmann
% calculates the interaction zones of the earthquakes
% in [km]
%Last modification 6/95

%global newcat rfact xmeff

if var1==1
rmain = 0.011*10.^(0.4*newcat(:,6)); %interaction zone for mainshock
%rmain = 10.^(-2.44+(.59*newcat(:,6)));

%tm1=find(rmain==0.011);             %these eqs got no magnitude in the catalog
%tm2= 0.011*10^(0.4*xmeff);          %assume that for eqs with magnitude 0
%rmain(tm1)=tm2*ones(1,length(tm1)); %the real magnitude is around xmeff

r1    =rfact*rmain;                  %interaction zone if included in a cluster

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   funTaucalc.m%%%%%%%%%%%%%%%%%%%%%%0000644 0001751 0000764 00000001024 10347520376 014142  0%%%%%%%%%%%%%%%%%%%%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function [tau] = funTaucalc(xk,mbg,k1,xmeff,bgdiff,P)
%tauclac.m                                         A.Allmann
%routine to claculate the look ahead time for clustered events
%gives tau back

% global newcat xk mbg xmeff k1 P
% global top denom deltam bgdiff


deltam = (1-xk)*mbg(k1)-xmeff;        %delta in magnitude
if deltam<0
 deltam=0;
end;
denom  = 10^((deltam-1)*2/3);              %expected rate of aftershocks
top    = -log(1-P)*bgdiff;
tau    = top/denom;                        %equation out of Raesenberg paper

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%funTimediff.m%%%%%%%%%%%%%%%%%%%%%   0000644 0001751 0000764 00000001663 10347520376 014326  0%%%%%%%%%%%%%%%%%%%%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function [tdiff, ac]  = timediff(j,ci,tau,clus,k1,newcat,eqtime)                     
% timediff.m                                         A.Allmann
% calculates the time difference between the ith and jth event
% works with variable eqtime from function clustime.m
% gives the indices ac of the eqs not already related to cluster k1
% last modification 8/95
% global  clus eqtime k1 newcat

tdiff(1)=0;
n=1;
ac=[];
while tdiff(n) < tau       %while timedifference smaller than look ahead time

 if j <= length(newcat(:,1))     %to avoid problems at end of catalog
  n=n+1;
  tdiff(n)=eqtime(j)-eqtime(ci);
  j=j+1;

 else
  n=n+1;
  tdiff(n)=tau;
 end


end
k2=clus(ci);

j=j-2;
if k2~=0
 if ci~=j
  ac = (find(clus(ci+1:j)~=k2))+ci;      %indices of eqs not already related to
 end                                        %cluster k1
else
 if ci~=j                                    %if no cluster is found already
  ac = ci+1:j;
 end
end
%%%%%%%%%%%%%%%%%%% GKDeclus.m%%%%%%%%%%%%%%%%%%%%%%  0000644 0001751 0000764 00000023566 10353235271 013527  0%%%%%%%%%%%%%%%%%%%%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function [mCatDecluster, mCatAfter, vCluster, vCl, vMainCluster] = GKDeclus(mCatalog)
% function [mCatDecluster, mCatAfter, vCluster, vCl, vMainCluster] = calc_decluster(mCatalog)
% ----------------------------------------------------------------------------------------------------------
%
% Function to decluster earthquake catalog using the Windowing technique in space and time by
% Knopoff & Gardner, GJR astr. Soc, 28, 311-313, 1972
% Gardner & Knopoff, BSSA, 64,5, 1363-1367, 1974
% using different windows
%
% Incoming variables
% mCatalog : Incoming earthquake catalog (ZMAP format)
% nMethod  : Window length for declustering (see calc_windows.m)
%            1: Gardener & Knopoff, 1974
%            2: Gruenthal pers. communication
%            3: Urhammer, 1986
%
% Outgoing variables:
% mCatDecluster : Declustered earthquake catalog
% mCatAfter     : Catalog of aftershocks (and foreshocks)
% vCluster      : Vector indicating only aftershocks/foreshocls in cluster using a cluster number
% vCl           : Vector indicating all events in clusters using a cluster number
% vMainCluster  : Vector indicating mainshocks of clusters using a cluster number
%
% J. Woessner, woessner@seismo.ifg.ethz.ch
% last update: 29.08.02

%% Added:
% 31.07.02 Correction for problem of mainshocks with a cluster number as aftershocks belong to two sequences
% 31.07.02 Corrected fMaxClusterMag(nMagCount) to fMaxClusterMag, since counting variable not needed
% 31.07.02 Improved resizing time window by adding time difference from initial event to bigger aftershock
% 13.08.02 Added waitbars
% 28.08.02 Changed distance determination using now distance and repmat
% 29.08.02 Cluster determination strategy change: Now selecting all aftershocks using the window of the first shock,
%          adding the events from the bigger aftershocks (later labelled mainshocks); calc_decluster_ver3.m keeps
%          resizing technique

%%% Remember: Improve zero length cluster problem which might appear

%% Initialize Vectors and Matrices
mCatDecluster = [];
mCatAfter = [];
vCluster = zeros(length(mCatalog),1); % Initialize all events as mainshock
vCl = zeros(length(mCatalog),1); % Initialize all events as mainshock
vSel = zeros(length(mCatalog),1); % Initialize all events as mainshock
vMainCluster = zeros(length(mCatalog),1); % Initialize

[nXSize, nYsize] = size(mCatalog);
if nXSize == 0
    disp('Load new catalog');
    return
end

vDecDate = mCatalog(:,3);
nCount = 0;    % Variable of cluster number

fMagThreshold = min(mCatalog(:,6)); % Set Threshold to minimum magnitude of catalog
% hWaitbar1 = waitbar(0,'Identifying clusters...');
% set(hWaitbar1,'Numbertitle','off','Name','Decluster percentage');
for nEvent=1:length(mCatalog(:,6))
    %nEvent
    %nCount
    if vCluster(nEvent) == 0
        fMagnitude(nEvent) = mCatalog(nEvent, 6);
        if fMagnitude(nEvent) >= fMagThreshold
            %% Define first aftershock zone and determine magnitude of strongest aftershock
            fMag = fMagnitude(nEvent);
% vst       Replace following line
%             [fSpace, fTime] = calc_windows(fMagnitude(nEvent), nMethod);
%           with these (to perform simulation over aftershockspace)
            [fSpace, fTime]=CalcMonteGKWinParms(fMagnitude(nEvent));
            fSpaceDeg = km2deg(fSpace);
            %% This first if is for events with no location given
            if isnan(mCatalog(nEvent,1))
                %vSel = (vDecDate(:,1)-vDecDate(nEvent,1) >= 0) & (vDecDate(:,1)-vDecDate(nEvent,1) <= fTime  & vCluster(nEvent) == 0);
                vSel = (mCatalog(:,3) == mCatalog(nEvent,3));
            else
                mPos = [mCatalog(nEvent, 1) mCatalog(nEvent,2)];
                mPos = repmat(mPos,length(mCatalog(:,1)), 1);
                mDist = abs(distance(mCatalog(:,1), mCatalog(:,2), mPos(:,1), mPos(:,2)));
                vSel = ((mDist <= fSpaceDeg) & (vDecDate(:,1)-vDecDate(nEvent,1) >= 0) &...
                    (vDecDate(:,1)-vDecDate(nEvent,1) <= fTime) & vCluster(nEvent) == 0);
            end;% End of isnan(mCatalog)
            mTmp = mCatalog(vSel,:);
            if length(mTmp(:,1)) == 1  % Only one event thus no cluster; IF to determine cluster or not
                fMaxClusterMag = fMag;
            else
                fMaxClusterMag = max(mTmp(:,6));
                [nIndiceMaxMag] = find(mTmp(:,6) == fMaxClusterMag);
                fTimeMaxClusterMag = mTmp(max(nIndiceMaxMag),3);
                % Search for event with bigger magnitude in cluster and add to cluster
                while fMaxClusterMag-fMag > 0
% vst               Replace calc_windows by CalcMonteGKWinParms
%                     [fSpace, fTime] = calc_windows(fMaxClusterMag, nMethod);
                    [fSpace, fTime] = CalcMonteGKWinParms(fMaxClusterMag);
                    fSpaceDeg = km2deg(fSpace);
                    %% Adding aftershocks from bigger aftershock
                    mPos = [mTmp(min(nIndiceMaxMag),1) mTmp(min(nIndiceMaxMag),2)];
                    mPos = repmat(mPos,length(mCatalog(:,1)), 1);
                    mDist = abs(distance(mCatalog(:,1), mCatalog(:,2), mPos(:,1), mPos(:,2)));
                    vSel2 = ((mDist <= fSpaceDeg) & (vDecDate(:,1)-mTmp(min(nIndiceMaxMag),3) >= 0) &...
                        (vDecDate(:,1)-mTmp(min(nIndiceMaxMag),3) <= fTime) & vCluster == 0);
                    mTmp = mCatalog(vSel2,:);
                    vSel = (vSel > 0 | vSel2 > 0); % Actual addition
                    if isempty(mTmp) % no events in aftershock zone
                        break;
                    end;
                    fMag = fMaxClusterMag;
                    fMaxClusterMag = max(mTmp(:,6));
                    [nIndiceMaxMag] = find(mTmp(:,6) == fMaxClusterMag);
                    fTimeMaxClusterMag = mTmp(max(nIndiceMaxMag),3);
                    if fMaxClusterMag - fMag == 0 % no bigger event in aftershock zone
                        break;
                    end;
                end;  % End of while
                nCount = nCount + 1; % Set cluster number
            end; % End of if length(mTmp)

            [vIndice]=find(vSel); % Vector of indices with Clusters
            vTmpCluster(vIndice,:) = nCount;
            %length(vTmpCluster(vIndice,:));
            nI=1; % Variable counting the length of the cluster
            % Select the right numbers for the cluster using the indice vector vIndice
            % First: Insert cluster number after check for length
            % Second: Check if it's a mainshock
            % Third: Keep the former cluster indice;
            while nI <= length(vIndice)
                if (~isempty(vTmpCluster(vIndice(nI))) & length(vTmpCluster(vIndice,:)) > 1 & vCluster(vIndice(nI)) == 0)
                    vCluster(vIndice(nI)) = vTmpCluster(vIndice(nI));
                    %vEventnr(vIndice,:) = nEvent;
                elseif  (~isempty(vTmpCluster(vIndice(nI))) & length(vTmpCluster(vIndice,:)) == 1 & vCluster(vIndice(nI)) == 0)
                    vCluster(vIndice(nI)) = 0;
                else
                    vCluster(vIndice(nI)) = vCluster(vIndice(nI));
                end;
                nI=nI+1;
            end; %End of while nI
            %                 nCount = nCount + 1; % Set cluster number %% Watch
            %             end; % End of if to determine cluster or not %% Watch
            %%% Check if the Cluster is not just one event which can happen in case of keeping the former
            %%% cluster number in preceeding while-Loop
            vSelSingle = (vCluster == nCount);
            [vIndiceSingle] = find(vSelSingle);
            %vTmpSingle(vIndiceSingle,:);
            if length(vIndiceSingle) == 1
                %nCount
                %vIndiceSingle
                vCluster(vIndiceSingle)=0; % Set the event as mainsock
                nCount = nCount-1; % Correct the cluster number down by one
            end;
        end; % End of if checking magnitude threshold fMagThreshold
    end; % End of if checking if vCluster == 0
%     if rem(nEvent,100) == 0
%         waitbar(nEvent/length(mCatalog(:,6)))
%     end; % End updating waitbar
end; % End of FOR over mCatalog
% close(hWaitbar1);
%nCount
%% vCL Cluster vector with mainshocks in it; vCluster is now modified to get rid of mainshocks
vCl = vCluster;

%% Matrix with cluster indice, magnitude and time
mTmpCat = [vCluster mCatalog(:,6) mCatalog(:,3)];
%% Delete largest event from cluster series and add to mainshock catalog
% hWaitbar2 = waitbar(0,'Identifying mainshocks in clusters...');
% set(hWaitbar2,'Numbertitle','off','Name','Mainshock identification ');
for nCevent = 1:nCount
    %nCevent
    vSel4 = (mTmpCat(:,1) == nCevent); % Select cluster
    mTmpCat2 = mCatalog(vSel4,:);
    fTmpMaxMag = max(mTmpCat2(:,6)); % Select max magnitude of cluster
    vSelMag = (mTmpCat2(:,6) == fTmpMaxMag);
    [nMag] = find(vSelMag);
    if length(nMag) == 1
        vSel5 = (mTmpCat(:,1) == nCevent & mTmpCat(:,2) == fTmpMaxMag); % Select the event
        [vIndiceMag] = find(vSel5); % Find indice
        vCluster(vIndiceMag) = 0;  % Set cluster value to zero, so it is a mainshock
        vMainCluster(vIndiceMag) = nCevent; % Set mainshock vector to cluster number
    elseif length(nMag) == 0
        disp('Nothing in ')
        nCevent
    else
        vSel = (mTmpCat(:,1) == nCevent & mTmpCat(:,2) == fTmpMaxMag);
        mTmpCat3 = mCatalog(vSel,:);
        [vIndiceMag] = min(find(vSel)); % Find minimum indice of event with max magnitude in cluster
        vCluster(vIndiceMag) = 0;  % Set cluster value to zero, so it is a mainshock
        vMainCluster(vIndiceMag) = nCevent;  % Set mainshock vector to cluster number
    end;
%     if rem(nCevent,20) == 0
%         waitbar(nCevent/nCount)
%     end; % End updating waitbar
end; % End of For nCevent
% close(hWaitbar2);
%% Create a catalog of aftershocks (mCatAfter) and of declustered catalog (mCatDecluster)
vSel = (vCluster(:,1) > 0);
mCatDecluster=mCatalog(~vSel,:);
mCatAfter = mCatalog(vSel,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  loadDec_ParmSpace.m%%%%%%%%%%%%%%%%%%%% 0000644 0001751 0000764 00000001623 10347520376 015350  0%%%%%%%%%%%%%%%%%%%%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function[] =loadDec_ParmSpace(numSim)

resFileIn = '/home/matt/mProjects/MonteDeclus/Results/decRes_xk.mat';
parmFileIn = '/home/matt/mProjects/MonteDeclus/Results/decParm_xk.mat';

load(resFileIn);
load(parmFileIn);
for simNum = 1:numSim
    decCat = decResult{simNum};
    [numEvents4(simNum) wRes4(simNum)] = size(decCat);
    isG5 = decCat(:,6) >= 5;
    numEvents5(simNum) = sum(isG5);

    taumin(simNum) = monteParms{simNum}(1);
    taumax(simNum) = monteParms{simNum}(2);
    P(simNum) = monteParms{simNum}(3);
    xk(simNum) = monteParms{simNum}(4);
    xmeff(simNum) = monteParms{simNum}(5);
    rfact(simNum) = monteParms{simNum}(6);
    err(simNum) = monteParms{simNum}(7);
    derr(simNum) = monteParms{simNum}(8);
end


figure
%plot(numEvents5,.8:.01:1,'+g');
plot(numEvents5,0:.1:1,'+g');
%plot(numEvents5,1:1:20,'+g');
%plot(numEvents5,.2:.1:5,'+g');
%plot(numEvents5,0:1:40,'+m');


title('XK')%%%%%%%%%%%%%%%%%%%%%%%%%%% loadDecRes.m%%%%%%%%%%%%%%%%%%%%%%0000644 0001751 0000764 00000003703 10347520376 014070  0%%%%%%%%%%%%%%%%%%%%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function[] =loadDecRes(numSim)

resFileIn = '/home/matt/mProjects/MonteDeclus/Results/DeclusResFixP.mat';
parmFileIn = '/home/matt/mProjects/MonteDeclus/Results/DeclusParmsFixP.mat';

load(resFileIn);
load(parmFileIn);
for simNum = 1:numSim
    decCat = decResult{simNum};
    [numEvents4(simNum) wRes4(simNum)] = size(decCat);
    isG5 = decCat(:,6) >= 5;
    numEvents5(simNum) = sum(isG5);

    taumin(simNum) = monteParms{simNum}(1);
    taumax(simNum) = monteParms{simNum}(2);
    P(simNum) = monteParms{simNum}(3);
    xk(simNum) = monteParms{simNum}(4);
    xmeff(simNum) = monteParms{simNum}(5);
    rfact(simNum) = monteParms{simNum}(6);
    err(simNum) = monteParms{simNum}(7);
    derr(simNum) = monteParms{simNum}(8);
end

[Vals E4ind] = sort(numEvents4);
sortedE4 = numEvents4(E4ind);
stmin4 = taumin(E4ind);
stmax4 = taumax(E4ind);
sP4 = P(E4ind);
sxk4 = xk(E4ind);
sxmeff4 = xmeff(E4ind);
srfact4 = rfact(E4ind);
serr4 = err(E4ind);
sderr4 = derr(E4ind);
minE4 = min(sortedE4);
maxE4 = max(sortedE4);
histStepE4 = minE4:(maxE4-minE4)/100:maxE4;
histE4 = hist(sortedE4,histStepE4);

[Vals E5ind] = sort(numEvents5);
sortedE5 = numEvents5(E5ind);
stmin5 = taumin(E5ind);
stmax5 = taumax(E5ind);
sP5 = P(E5ind);
sxk5 = xk(E5ind);
sxmeff5 = xmeff(E5ind);
srfact5 = rfact(E5ind);
serr5 = err(E5ind);
sderr5 = derr(E5ind);
minE5 = min(sortedE5);
maxE5 = max(sortedE5);
histStepE5 = minE5:(maxE5-minE5)/100:maxE5;
histE5 = hist(sortedE5,histStepE5);

disp(['taumin: ',num2str(min(taumin)),' ',num2str(max(taumin))]);
disp(['taumax: ',num2str(min(taumax)),' ',num2str(max(taumax))]);

disp(['P: ',num2str(min(P)),' ',num2str(max(P))]);
disp(['rfact: ',num2str(min(rfact)),' ',num2str(max(rfact))]);
disp(['xk: ',num2str(min(xk)),' ',num2str(max(xk))]);
disp(['xmeff: ',num2str(min(xmeff)),' ',num2str(max(xmeff))]);

figure
plot(numEvents5,rfact,'.k');
figure
hist(numEvents5);


%figure
%plot(histStepE4,cumsum(histE4),'k');
%figure
%plot(histStepE5,cumsum(histE5),'r');
%%%%%%%%%%%%%%% MonteGK.m%%%%%%%%%%%%%%
%%%%%%%%   0000644 0001751 0000764 00000001164 10353237156 013364  0%%%%%%%%%%%%%
%%%%%%%%%%%%ustar   thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%function [mCatalog_, mNumDeclus] = MonteGK(mCatalog_,nSimul_)

% [fSpaceRange,fTimeRange] = CalcMonteGKWinParms();
% fSpaceDiff = fSpaceRange(2) - fSpaceRange(1);
% fTimeDiff = fTimeDiff(2) - fTimeDiff(1);

mCatalog_(:,10)=zeros(size(mCatalog_,1),1);
mNumDeclus=[];

for simNum = 1:nSimul_
%     nRand = rand(1,2);
%     fSpace = fSpaceRange(1) + fSpaceDiff*nRand(1);
%     fTime = fTimeRange(1) + fTimeDiff*nRand(2);
    simNum
    [mCatDecluster, mCatAfter, vCluster, vCl, vMainCluster] = GKDeclus(mCatalog_);
    vSel=~(vCluster(:,1) > 1 );
    mNumDeclus=[mNumDeclus,vSel];
    mCatalog_(:,10)=mCatalog_(:,10)+vSel;

end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%MonteReasenberg.m%%%%%%%%%%%%%%%
%%%%%   0000644 0001751 0000764 00000006415 10357045603 015142  0%%%%%%%%%%%%%%%%
%%%%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%function [declusCat,mNumDeclus] = MonteReasenberg(numSim,Cat)

%%
% Wrapper function to do Monte Carlo simulations of the
% input parameters into the Reasenberg Declustering algorithm
%%

% if ~exist('FileOut','var')
%     disp(['You must give me the output results filename!'])
%     return
% end

resFileOut = 'DeclusRes';
parmFileOut = 'DeclusParms';
mNumDeclus=[];

%  default values
dfTaumin = 1;
dfTaumax = 10;
dfP = 0.95;
dfXk = 0.5;
dfXmeff = 1.5;
dfRfact = 10;
dfErr=1.5;
dfDerr=2;

% %%
% % set Default ranges for Reasenberg input variables and find their range
% raTaumin = [1 10];
% raTaumax = [1 100];
% raP = [.8 1];
% raXk = [0 1];
% raXmeff = [4 4];
% raRfact = [1 20];
% raErr = [.5 5];
% raDerr = [2 5];

% %%
% % set Default ranges for Reasenberg input variables and find their range
% raTaumin = [.9 1.1];
% raTaumax = [8 12];
% raP = [.94 .96];
% raXk = [0.45 0.55];
% raXmeff = [1.5 1.5];
% raRfact = [8 12];
% raErr = [1.4 1.6];
% raDerr = [2 2];

%%
% set Default ranges for Reasenberg input variables and find their range
raTaumin = [.5 2.5];
raTaumax = [3 20];
raP = [.9 .999];
raXk = [0.4 0.6];
raXmeff = [2.7 2.9];
raRfact = [5 20];
raErr = [2 4];
raDerr = [4 6];

% raTaumin = [.5 .5];
% raTaumax = [10 10];
% raP = [0.99 0.99];
% raXk = [0.5 0.5];
% raXmeff = [3 3];
% raRfact = [10 10];
% raErr=[1.5];
% raDerr=2;



tauminDiff = (raTaumin(2) - raTaumin(1));
taumaxDiff = (raTaumax(2) - raTaumax(1));
pDiff = (raP(2) - raP(1));
xkDiff = (raXk(2) - raXk(1));
xmeffDiff = (raXmeff(2) - raXmeff(1));
rfactDiff = (raRfact(2) - raRfact(1));
%errDiff = raErr(2) - raErr(1);
%derrDiff = raDerr(2) - raDerr(1);

%% add column for independence probability (actually will just be number of
%% times the event has appeared in a catalogue (will need to divide by
%% simNum to get P

Cat(:,10) = 0;

% set the rand number generator state
rand('state',sum(100*clock));

% simulate parameter values and run the delcustering code
for simNum = 1:numSim

    randNum = rand(1,8);
    lTaumin = raTaumin(1) + tauminDiff*randNum(1);
    lTaumax = raTaumax(1) + taumaxDiff*randNum(2);
    lP = raP(1) + pDiff*randNum(3);
    lXk = raXk(1) + xkDiff*randNum(4);
    lXmeff = raXmeff(1) + xmeffDiff*randNum(5);
%     lXmeff = raXmeff(1) ;
    lRfact = raRfact(1) + rfactDiff*randNum(6);
    %lErr = raErr(1) + errDiff*randNum(7);
    %lDerr = raDerr(1) + derrDiff*randNum(8);
    lErr = raErr(1);
    lDerr = raDerr(1);

    [declusCat,is_mainshock] = ReasenbergDeclus(lTaumin,lTaumax,lXk,lXmeff,lP,lRfact,lErr,lDerr,Cat);


    Cat(is_mainshock,10) = Cat(is_mainshock,10) + 1;
    nIst=zeros(length(Cat),1);
    nIst(is_mainshock)=1;
    nIst=logical(nIst);
    mNumDeclus=[mNumDeclus,(nIst==1)];
    %decResult(simNum) = {Cat};
    save(resFileOut,'Cat');

    monteParms(simNum) = {[lTaumin;lTaumax;lP;lXk;lXmeff;lRfact;lErr;lDerr]};
    save(parmFileOut,'monteParms');
    disp(num2str(simNum));

    isLanders = declusCat(:,6) == 7.3;
    if sum(isLanders) == 0
        disp([num2str(monteParms{simNum}')]);
    end

    sim_FileName = ['~/zmap/results/MonteDeclus/Results/',num2str(simNum),'.mat'];
    save(sim_FileName,'simNum');


    try
        delsim_FileName = ['~/zmap/results/MonteDeclus/Results/',num2str(simNum-1),'.mat'];
        delete(delsim_FileName);
    catch
    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Param_Space.m%%%%%%%%%%%%%
%%%%%%%%   0000644 0001751 0000764 00000004553 10347520376 014242  0%%%%%%%%%%%%%%%%
%%%%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%function[] = Param_Space(Cat)

lTaumin = [1];
lTaumax = [10];
lP = [.95];
lXk = [.4];
lXmeff = [3];
lRfact = [10];
lErr = [2];
lDerr = [5];



%% loop for P

resFileOut = 'decResP';
parmFileOut = 'decParmP';
P_Sim = .8:.01:1;
numSim = length(P_Sim);


for simNum = 1:numSim
    [declusCat] = ReasenbergDeclus(lTaumin,lTaumax,lXk,lXmeff,P_Sim(simNum),lRfact,lErr,lDerr,Cat);
    decResult(simNum) = {declusCat};
    save(resFileOut,'decResult');

    monteParms(simNum) = {[lTaumin;lTaumax;lP;lXk;lXmeff;lRfact;lErr;lDerr]};
    save(parmFileOut,'monteParms');
    disp(num2str(simNum));
end


%% loop for Taumin

resFileOut = 'decResTmin';
parmFileOut = 'decParmTmin';
T_Sim = .2:.1:5;
numSim = length(T_Sim);


for simNum = 1:numSim
    [declusCat] = ReasenbergDeclus(T_Sim(simNum),lTaumax,lXk,lXmeff,lP,lRfact,lErr,lDerr,Cat);
    decResult(simNum) = {declusCat};
    save(resFileOut,'decResult');

    monteParms(simNum) = {[lTaumin;lTaumax;lP;lXk;lXmeff;lRfact;lErr;lDerr]};
    save(parmFileOut,'monteParms');
    disp(num2str(simNum));
end

%% loop for Taumax

resFileOut = 'decResTmax';
parmFileOut = 'decParmTmax';
T_Sim = 1:1:20;
numSim = length(T_Sim);


for simNum = 1:numSim
    [declusCat] = ReasenbergDeclus(lTaumin,T_Sim(simNum),lXk,lXmeff,lP,lRfact,lErr,lDerr,Cat);
    decResult(simNum) = {declusCat};
    save(resFileOut,'decResult');

    monteParms(simNum) = {[lTaumin;lTaumax;lP;lXk;lXmeff;lRfact;lErr;lDerr]};
    save(parmFileOut,'monteParms');
    disp(num2str(simNum));
end

%% loop for rFact

resFileOut = 'decRes_rFact';
parmFileOut = 'decParm_rFact';
R_Sim = 0:1:40;
numSim = length(R_Sim);


for simNum = 1:numSim
    [declusCat] = ReasenbergDeclus(lTaumin,lTaumax,lXk,lXmeff,lP,R_Sim(simNum),lErr,lDerr,Cat);
    decResult(simNum) = {declusCat};
    save(resFileOut,'decResult');

    monteParms(simNum) = {[lTaumin;lTaumax;lP;lXk;lXmeff;lRfact;lErr;lDerr]};
    save(parmFileOut,'monteParms');
    disp(num2str(simNum));
end

%% loop for xK

resFileOut = 'decRes_xk';
parmFileOut = 'decParm_xk';
Xk_Sim = 0:.1:1;
numSim = length(Xk_Sim);


for simNum = 1:numSim
    [declusCat] = ReasenbergDeclus(lTaumin,lTaumax,Xk_Sim(simNum),lXmeff,lP,lRfact,lErr,lDerr,Cat);
    decResult(simNum) = {declusCat};
    save(resFileOut,'decResult');

    monteParms(simNum) = {[lTaumin;lTaumax;lP;lXk;lXmeff;lRfact;lErr;lDerr]};
    save(parmFileOut,'monteParms');
    disp(num2str(simNum));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P_Space_Reasen.m%%%%%%%%%%%%%%%%%%%%%0000644 0001751 0000764 00000004124 10347520376 014670  0%
%%%%%%%%%%%%%%%%%%%%%%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%function[] = MonteReasenberg(numSim,Cat)

%%
% Wrapper function to do Monte Carlo simulations of the
% input parameters into the Reasenberg Declustering algorithm
%%

% if ~exist('FileOut','var')
%     disp(['You must give me the output results filename!'])
%     return
% end
resFileOut = 'Results/DeclusResFixP';
parmFileOut = 'Results/DeclusParmsFixP';

%  default values
dfTaumin = 1;
dfTaumax = 10;
dfP = 0.95;
dfXk = 0.5;
dfXmeff = 1.5;
dfRfact = 10;
dfErr=1.5;
dfDerr=2;

% %%
% % set Default ranges for Reasenberg input variables and find their range
% raTaumin = [1 10];
% raTaumax = [1 100];
% raP = [.8 1];
% raXk = [0 1];
% raXmeff = [4 4];
% raRfact = [1 20];
% raErr = [.5 5];
% raDerr = [2 5];


%%
% set Default ranges for Reasenberg input variables and find their range
raTaumin = [1 1];
raTaumax = [10 10];
raP = [.8 1.0];
raXk = [.4 .4];
raXmeff = [4 4];
raRfact = [10 10];
raErr = [2 2];
raDerr = [5 5];



tauminDiff = (raTaumin(2) - raTaumin(1));
taumaxDiff = (raTaumax(2) - raTaumax(1));
pDiff = (raP(2) - raP(1));
xkDiff = (raXk(2) - raXk(1));
xmeffDiff = (raXmeff(2) - raXmeff(1));
rfactDiff = (raRfact(2) - raRfact(1));
errDiff = raErr(2) - raErr(1);
derrDiff = raDerr(2) - raDerr(1);

% set the rand number generator state
rand('state',sum(100*clock));

P_Sim = .8:.01:1;
numP = length(P_Sim);

% simulate parameter values and run the delcustering code
for simNum = 1:numP

    randNum = rand(1,8);
    lTaumin = raTaumin(1) + tauminDiff*randNum(1);
    lTaumax = raTaumax(1) + taumaxDiff*randNum(2);
    %lP = raP(1) + pDiff*randNum(3);
    lP = P_Sim(simNum);
    lXk = raXk(1) + xkDiff*randNum(4);
    lXmeff = raXmeff(1) + xmeffDiff*randNum(5);
    lRfact = raRfact(1) + rfactDiff*randNum(6);
    lErr = raErr(1) + errDiff*randNum(7);
    lDerr = raDerr(1) + derrDiff*randNum(8);


    [declusCat] = ReasenbergDeclus(lTaumin,lTaumax,lXk,lXmeff,lP,lRfact,lErr,lDerr,Cat);
    decResult(simNum) = {declusCat};
    save(resFileOut,'decResult');

    monteParms(simNum) = {[lTaumin;lTaumax;lP;lXk;lXmeff;lRfact;lErr;lDerr]};
    save(parmFileOut,'monteParms');
    disp(num2str(simNum));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ReasenbergDeclus.m%%%%%%%%%%%%%%%%%
%%%  0000644 0001751 0000764 00000017266 10347520376 015311  0%%%%%%%%%%%%%%%%%%%%%%
%%%ustar thomas%%%%%%  thomas%%%%%%  0000000 0000000%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function[a,is_mainshock] = ReasenbergDeclus(taumin,taumax,xk,xmeff,P,rfact,err,derr,newcat) 
% declus.m                                A.Allmann
% main decluster algorithm
% modified version, uses two different circles for already related events
% works on newcat
% different clusters stored with respective numbers in clus
% Program is based on Raesenberg paper JGR;Vol90;Pages5479-5495;06/10/85
% Last change 8/95


% variables given by inputwindow
%
% rfact  is factor for interaction radius for dependent events (default 10)
% xmeff  is "effective" lower magnitude cutoff for catalog,it is raised
%         by a factor xk*cmag1 during clusters (default 1.5)
% xk     is the factor used in xmeff    (default .5)
% taumin is look ahead time for not clustered events (default one day)
% taumax is maximum look ahead time for clustered events (default 10 days)
% P      to be P confident that you are observing the next event in
%        the sequence (default is 0.95)



%basic variables used in the program
%
% rmain  interaction zone for not clustered events
% r1     interaction zone for clustered events
% rtest  radius in which the program looks for clusters
% tau    look ahead time
% tdiff  time difference between jth event and biggest eq
% mbg    index of earthquake with biggest magnitude in a cluster
% k      index of the cluster
% k1     working index for cluster

%routine works on newcat

%disp('This is src/declus/declus')



%declaration of global variables
%
% global newcat clus rmain r1 eqtime              %catalogs
% global  a                                       %catalogs
% global k k1 bg mbg bgevent equi bgdiff          %indices
% global ltn  hoda                                %variable to shorten code
% global clust clustnumbers cluslength            %used in buildclu
% global faults coastline main mainfault name
% global xmeff xk rfact taumin taumax P
% global err derr ijma org2

bg=[];k=[];k1=[];mbg=[];bgevent=[];equi=[];bgdiff=[];clust=[];clustnumbers=[];
cluslength=[];rmain=[];r1=[];


man =[taumin;taumax;xk;xmeff;P;rfact;err;derr;];

[rmain,r1]=funInteract(1,newcat,rfact,xmeff);                     %calculation of interaction radii

limag=find(newcat(:,6)>=6);     % index of earthquakes with magnitude bigger or
% equal magnitude 6
if isempty(limag)
   limag=0;
end

%calculation of the eq-time relative to 1902
eqtime=funClustime(1,newcat);

%variable to store information wether earthquake is already clustered
clus = zeros(1,length(newcat(:,1)));

k = 0;                                %clusterindex

ltn=length(newcat(:,1))-1;

% wai = waitbar(0,' Please Wait ...  ');
% set(wai,'NumberTitle','off','Name','Decluster - Percent done');
% drawnow

%for every earthquake in newcat, main loop
for i = 1:ltn

   % variable needed for distance and timediff
   j=i+1;
   k1=clus(i);

   % attach interaction time
   if k1~=0                          %If i is already related with a cluster
      if newcat(i,6)>=mbg(k1)          %if magnitude of i is biggest in cluster
         mbg(k1)=newcat(i,6);            %set biggest magnitude to magnitude of i
         bgevent(k1)=i;                  %index of biggest event is i
         tau=taumin;
      else
         bgdiff=eqtime(i)-eqtime(bgevent(k1));
         tau = funTaucalc(xk,mbg,k1,xmeff,bgdiff,P);
         if tau>taumax
            tau=taumax;
         end
         if tau<taumin
            tau=taumin;
         end
      end
   else
      tau=taumin;
   end

   %extract eqs that fit interation time window
   [tdiff,ac]=funTimediff(j,i,tau,clus,k1,newcat,eqtime);


   if size(ac)~=0   %if some eqs qualify for further examination

      if k1~=0                       % if i is already related with a cluster
         tm1=find(clus(ac)~=k1);       %eqs with a clustnumber different than i
         if ~isempty(tm1)
            ac=ac(tm1);
         end
      end
      if tau==taumin
         rtest1=r1(i);
         rtest2=0;
      else
         rtest1=r1(i);
         rtest2=rmain(bgevent(k1));
      end

      %calculate distances from the epicenter of biggest and most recent eq
      if k1==0
         [dist1,dist2]=funDistance(i,i,ac,newcat,err,derr);
      else
         [dist1,dist2]=funDistance(i,bgevent(k1),ac,newcat,err,derr);
      end;
      %extract eqs that fit the spatial interaction time
      sl0=find(dist1<= rtest1 | dist2<= rtest2);

      if size(sl0)~=0    %if some eqs qualify for further examination
         ll=ac(sl0);       %eqs that fit spatial and temporal criterion
         lla=ll(find(clus(ll)~=0));   %eqs which are already related with a cluster
         llb=ll(find(clus(ll)==0));   %eqs that are not already in a cluster
         if ~isempty(lla)            %find smallest clustnumber in the case several
            sl1=min(clus(lla));            %numbers are possible
            if k1~=0
               k1= min([sl1,k1]);
            else
               k1 = sl1;
            end
            if clus(i)==0
               clus(i)=k1;
            end
            %merge all related clusters together in the cluster with the smallest number
            sl2=lla(find(clus(lla)~=k1));
            for j1=[i,sl2]
               if clus(j1)~=k1
                  sl5=find(clus==clus(j1));
                  tm2=length(sl5);
                  clus(sl5)=k1*ones(1,tm2);
               end
            end
         end

         if k1==0                    %if there was neither an event in the interaction
            k=k+1;                         %zone nor i, already related to cluster
            k1=k;
            clus(i)=k1;
            mbg(k1)=newcat(i,6);
            bgevent(k1)=i;
         end

         if size(llb)>0                   %attach clustnumber to events not already
            clus(llb)=k1*ones(1,length(llb));  %related to a cluster
         end

      end                          %if ac
   end                           %if sl0
end                            %for loop

if ~find(clus~=0)
    return
else
    [cluslength,bgevent,mbg,bg,clustnumbers] = funBuildclu(newcat,bgevent,clus,mbg,k1,bg);              %builds a matrix clust that stored clusters
%     equi=equevent;               %calculates equivalent events
%     if isempty(equi)
%         disp('No clusters in the catalog with this input parameters');
%         return;
%     end
   [a,is_mainshock] = funBuildcat(newcat,clus,bg,bgevent);        %new catalog for main program
%   original=newcat;       %save newcat in variable original
%    newcat=a;
%    org2 = original;
%    cluscat=original(find(clus),:);
%    subcata
%    hold on
%    plot(cluscat(:,1),cluscat(:,2),'m+');
%    st1 = [' The declustering found ' num2str(length(bgevent(:,1))) ' clusters of earthquakes, a total of '...
%          ' ' num2str(length(cluscat(:,1))) ' events (out of ' num2str(length(original(:,1))) '). '...
%          ' The map window now display the declustered catalog containing ' num2str(length(a(:,1))) ' events . The individual clusters are displayed as magenta o in the  map.  ' ];
%
%    msgbox(st1,'Declustering Information')
%
%
%    ans = questdlg('                                                           ',...
%       'Analyse clusters? ',...
%       'Yes please','No thank you','No' );
%
%    switch ans
%    case 'Yes please'
%          plotclust
%    case 'No thank you'
%
%       disp('Keep on going ...');
%
%    end

%    mete =...
%       ['  The declustered catalog has been saved  '
%       '  The map window now displays             '
%       '  the declusterd catalog!                 '];
%
%    watchoff,done;
%
%    % Plot the clusters
%   %  plotclust
%
%    welcome('Declustering done!',mete)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%  
