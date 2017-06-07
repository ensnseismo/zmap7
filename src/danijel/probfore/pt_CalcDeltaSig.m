function [fSigmaDistance, fMu, fSigma] = pt_CalcDeltaSig(mValues, fTestValue)
% function [fSignificanceLevel, fMu, fSigma] = pt_CalcDeltaSig(mValues, fTestValue)
% ---------------------------------------------------------------------------------
% Calculates the Delta_sigma measure of significance of fTestValue
%
% Input parameters:
%   mValues               Value distribution (assumed to be a normal distribution)
%   fTestValue            Value to be tested
%
% Output parameter:
%   fSigmaDistance        Delat_sigma measure
%   fMu                   Mu of distribution
%   fSigma                Sigma of distribution
%
% Danijel Schorlemmer
% April 14, 2003

global bDebug;
if bDebug
  report_this_filefun(mfilename('fullpath'));
end

% Select all non-NaN values of the distribution
vSelection = ~isnan(mValues);
mNoNanValues = mValues(vSelection);

% Compute the mean and standard deviation of the non-parameterized distribution
fMu = mean(mNoNanValues);
fSigma = calc_StdDev(mNoNanValues);

% Return the Delta_sigma measure of the testvalue (+: test hypothesis wins)
fSigmaDistance = (fMu - fTestValue)/fSigma;
