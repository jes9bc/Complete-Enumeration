function [OptCrit, pos, true_crit, thresh] = genDerivationVar(outRall,crit,overlap)
%This function generates an optimization criteria by randomly selecting an
%optimal solution from all possible optimal solutions and generating random
%numbers between 0 and 1

%input:
%   The completely enumerated search space
%   Matrix of criteria (1's and 0's indicating endorsement)

%output:
%   The pseudo optimization criteria
%   position of the true optimal solution (out of the full outRall input)

[n_crit, p_crit] = size(crit);

% randomly select a diagnostic rule to be the true rule
pos = randi(length(outRall));
opt_true = outRall(pos,:);

true_crit = opt_true(1:p_crit);
true_crit_copy = true_crit;
true_thresh = opt_true(end);
true_crit_copy(true_crit_copy==0) = [];
subset = crit(:,true_crit_copy);
subsetdiag = sum(subset,2)>=true_thresh;

prev = sum(subsetdiag)/sum(crosstab(subsetdiag));
ndmin=0;
ndmax=1-(prev-overlap);
if ndmax > 1
    ndmax = 1;
end
dmin = 1-(prev+overlap);
if dmin >1
    dmin = 1;
end
dmax = 1;

for r = 1:n_crit
    if subsetdiag(r) == 1
        OptCrit(r) = dmin + rand(1,1)*(dmax-dmin);
    else OptCrit(r) = ndmin+rand(1,1)*(ndmax-ndmin);
    end
end

thresh = true_thresh;
%

end







