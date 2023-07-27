function OUTSEQ = Signal2OPs(IDATAS)
%
%  This subroutine encodes a real-valued time-series into an integer-valued
% series, namely, a set of Ordinal Patterns (OPs). The encoding is obtained
% from the subroutine "OrderPattern", which compares the values within each
% sub-set of the time-series that "Signal2OrdPats" provides as input, i.e.,
% words of length EMBDIM. The resultant OP output from "OrderPattern" comes
% from a lexicographic dictionary that is based on ordering the word into a
% increasing-valued word by performing permutations, as explained within.
%
global  EMBDIM  DELAYS
%
%
%%% TIMES-SERIES ENCODING INTO ORDINAL PATTERNS (OPs)
N_DATA = length(IDATAS);        % length of input data set
ENDING = N_DATA - (EMBDIM - 1); % ending index for the encoding
OPSIZE = floor(ENDING/EMBDIM);  % approximate number of ordinal patterns
OUTSEQ = zeros(OPSIZE,1);       % memory allocation for OP sequence
JJ = 1;                         % initialize allocation counter
for IC = 1:EMBDIM-1             % ...start initial conditions loop...
    for NTAU = IC:DELAYS:ENDING     % ... start encoding loop ...
        INDEXS = NTAU:NTAU+(EMBDIM-1);  % time-series indexes for OP symbol
        T_WORD = IDATAS(INDEXS);        % word formed from input vaules
        PORDER = OrderPattern(T_WORD);	% resultant OP symbol for the word
        OUTSEQ(JJ) = PORDER;            % OP allocation into output
        JJ = JJ + 1;                    % update allocation counter
    end;                            % ... end encoding loop ...
end;                            % ...end initial conditions loop...
%
return;
end
%