function [SH_ENT,SH_VAR] = ShannonEnt(INPROB,N_SYMB)
%
%   This subrotuine computes the Shannon entropy [C. E. Shannon, Bell Syst.
% Tech. J. 27, 623-656 (1948)] for the input probabilities, INPROB, and the
% number of symbols used, N_SYMB, in the alphabet. INPROBs must be a column
% vector. Also, the variance of this quantity is computed, namely, SH_VAR.
%
NONULL = INPROB > 0;            % index for non-null probabilities
NEW_PS = INPROB(NONULL);        % new vector with only non-null probs.
AUXVAL = (NEW_PS')*log2(NEW_PS);% - Shannon entropy in bits per symbol
NEWVAL = -AUXVAL/log2(N_SYMB);	% Shannon entropy in N_SYMB per symbol
SH_ENT = NEWVAL;                % Shannon entropy output allocation
%
QPLOGS = (log2(1./NEW_PS)).^2;  % quadratic probability logarithms (QPL)
AUXVAL = (NEW_PS')*QPLOGS;      % average QPL value
NEWVAL = +AUXVAL/log2(N_SYMB)^2;% quadratic entropy in N_SYMB per symbol
SH_VAR = NEWVAL - SH_ENT^2;     % Shannon entropy variance
%
return;
end
%