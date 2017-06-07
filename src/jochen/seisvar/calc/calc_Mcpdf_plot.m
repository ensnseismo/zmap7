function calc_Mcpdf_plot(mCatalog, fBinning)
% function calc_Mcpdf_plot(mCatalog, fBinning);
% --------------------------------------------
% Determine Mc using maximum likelihood score
% Fitting non-cumulative frequency magnitude distribution above and below Mc:
% Use a PDF function to fit entire data but only fitted data below Mc
% above: Gutenberg-Richter law
%
% Incoming variables:
% mCatalog   : EQ catalog
% fBinning   : Binning interval, usually 0.1
%
% Outgoing variables:
%
% J. Woessner: woessner@seismo.ifg.ethz.ch
% last update: 05.11.02

% Initialize
vProbability = [];
vMc = [];
vABValue =[];
vX_res = [];
vNCumTmp = [];
mDataPred = [];

% Determine exact time period
fPeriod1 = max(mCatalog(:,3)) - min(mCatalog(:,3));

% Determine max. and min. magnitude
fMinMag = floor(min(mCatalog(:,6)));
if fMinMag > 0
  fMinMag = 0;
end
fMaxMag = ceil(10 * max(mCatalog(:,6))) / 10;

% Calculate FMD for original catalog
 [vFMD, vNonCFMD] = calc_FMD(mCatalog);
 vNonCFMD = fliplr(vNonCFMD);
for fMc = 0.8:0.1:3.5
    [nIndexLo, fMagHi, vSel, vMagnitudes] = fMagToFitBValue(mCatalog, vFMD, fMc);
    [fMeanMag, fBValue, fStdDev, fAValue] =  calc_bmemag(mCatalog(vSel,:), fBinning);
    % Compute quantity of earthquakes by power law
    vMstep = [fMinMag:0.1:fMaxMag];
    vNCum = 10.^(fAValue-fBValue.*vMstep); % Cumulative number
    % Compute non-cumulative numbers vN
    fNCumTmp = 10^(fAValue-fBValue*(fMaxMag+0.1));
    vNCumTmp  = [vNCum fNCumTmp];
    vN = abs(diff(vNCumTmp));
    % Data selection
    mData = [vN' vNonCFMD']
    % Normalize to fit PDF
    fNmax = max(mData(:,3));
    mData(:,3) = mData(:,3)/fNmax;
    % Curve fitting: Non cumulative FMD
    options = optimset;
    options = optimset('Display','iter','Tolfun',1e-6,'TolX',0.0001);
    vFun = inline('raylpdf(vXdata,vX(1))', 'vX', 'vXdata');
    [vX, resnorm, resid, exitflag, output, lambda, jacobian]=lsqcurvefit(vFun,3, mData(:,2), mData(:,3));
    % Denormalize
    mData(:,3) = mData(:,3)*fNmax;
    vSel = (mData(:,2) >= fMc);
    mDataTest = mData(~vSel,:)
    mDataTmp = mData(vSel,:)
    mDataTest(:,1) = raylpdf(mDataTest(:,2), vX(1))*fNmax;
%     [vX, resnorm, resid, exitflag, output, lambda, jacobian]=lsqcurvefit(@calc_,[0 1], mDataTest(:,2), mDataTest(:,3));
%     mDataTest(:,1) = logncdf(mDataTest(:,2), vX(1), vX(2));
     %% Set data together
    mDataPred = [mDataTest; mDataTmp]
    vProb_ = calc_log10poisspdf(vNonCFMD(2,:)', ceil(mDataPred(:,1)));

    % Sum the probabilities
    fProbability = (-1) * sum(vProb_);
    vProbability = [vProbability; fProbability];
    vMc = [vMc; fMc];
    vABValue = [vABValue; fAValue fBValue];

    %% Confidence interval
    [vPred,delta] = nlpredci(vFun,mDataTest(:,2),vX, resid, jacobian);

    figure_w_normalized_uicontrolunits(200)
    subplot(3,1,1)
    %plot(vFactor, exp(vFactor)-1);
    plot(mDataTest(:,2), mDataTest(:,1),'-r', mData(:,2), mData(:,3), '*')
    hold on;
    plot(vNonCFMD(1,:)', vNonCFMD(2,:),'g^')
    %figure_w_normalized_uicontrolunits(300)
    subplot(3,1,2)
    semilogy(vNonCFMD(1,:)', vNonCFMD(2,:)', '^', vNonCFMD(1,:)', vN, '*', vNonCFMD(1,:)',mDataPred(:,1),'o')
    subplot(3,1,3)
    %figure_w_normalized_uicontrolunits(310)
    plot(mDataTest(:,2),vPred)
    hold on
    plot(mDataTest(:,2), mDataTest(:,3),'+r')
    plot(mDataTest(:,2),vPred + delta,'--g')
    plot(mDataTest(:,2),vPred - delta,'--g')
    hold off;
    if (fProbability == min(vProbability))
        vPredBest = vPred;
        vDeltaBest = delta;
        mDat = mDataTest;
        vNBest = vN;
        fMcBest = fMc;
        mDatPredBest = mDataPred;
        vX_res = [vX resnorm exitflag];
    end
    % Clear variables
    vNCumTmp = [];
    mModelDat = [];
    vNCum = [];
    vSel = [];
    mDataTest = [];
    mDataPred = [];
end
figure_w_normalized_uicontrolunits(400)
plot(vMc, vProbability,'*');
figure_w_normalized_uicontrolunits(410)
plot(mDat(:,2),vPredBest)
hold on;
plot(mDat(:,2), mDat(:,3),'+r')
plot(mDat(:,2),vPredBest + vDeltaBest,'--g')
plot(mDat(:,2),vPredBest - vDeltaBest,'--g')
hold off;
figure_w_normalized_uicontrolunits(420)
semilogy(vNonCFMD(1,:)', vNonCFMD(2,:)', '^', vNonCFMD(1,:)', vNBest, '*', vNonCFMD(1,:)',mDatPredBest(:,1),'o')
sTitlestr = ['A ' num2str(vX(1)) ' * Mc at ' num2str(fMcBest)];
title(sTitlestr)
