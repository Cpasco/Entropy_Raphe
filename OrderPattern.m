function PORDER = OrderPattern(T_WORD)
%
%   This subroutine performs a series of permutations to arrange the input,
% T_WORD, into a monotonically increasing word of size: EMBDIM. The output,
% PORDER, is the number of permutations needed to create this ordering + 1.
%   This choice of encoding defines a lexicographic dictionary as a result.
% For example, if EMBDIM = 3 (T_WORD has 3 consecutive time-series values),
% the six possible output values for PORDER are:
%           WORDS	 PORDER
%           (123)       1
%           (132)       2
%           (213)       3
%           (231)       4
%           (312)       5
%           (321)       6
% where, (123), indicates that the difference between consectuvie values is
% increasing, contrary to (321). In other words, (123), requires no further
% ordering, hence, zero permutations (i.e., PORDER = 1). In opposition, the
% word (321) requires 5 permutations in total (i.e., PORDER = 3 + 2 + 1).
%
%%% PERMUTATION ORDER FOR EMBEDING WORD:
AUXVAR = T_WORD;                % auxiliary word allocation
STATUS = 0;                     % initialize the number of permutations
for NN = 1:length(T_WORD)-1     % ... start word ordering loop ...
    %
    % FIND MINIMUM VALUE OF THE WORD
    MINVAL = min(AUXVAR);           % minimum (variable) word value
	CHOOSE = find(AUXVAR == MINVAL);% location of minimum
    W_LONG = length(AUXVAR);        % length of (variable) word
	POSIBS = factorial(W_LONG - 1); % remaining permutations in word
    %
    % UPDATE THE STATUS OF THE WORD WITHIN THE LEXICOGRAPH ASSIGNED
    UPDATE = (CHOOSE(1)-1)*POSIBS;	% updated state of the permutations
	STATUS = STATUS + UPDATE;       % update symbol of OP (permutations)
    INDEXS = 1:W_LONG;              % indexes of word values
    NEWIND = INDEXS ~= CHOOSE(1);	% remove minimum from word
    TEMPOR = AUXVAR(NEWIND);        % keep remaining letters in the word
    AUXVAR = TEMPOR;                % update word without minimum value
    %
end;                            % ... end word ordering loop ...
%
%%% RESULTING PERMUTATION
PORDER = STATUS + 1;            % final permutation status
%
return;
end