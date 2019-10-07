function [insamp_mean_cohens, insamp_mean_prev, outsamp_mean_cohens, outsamp_mean_prev, cand_sum] = opt_mult_it(crit, consump, br, it)
% opt_mult_iterations performs the CV optimization across a number of times
% to ensure that the of the optimization are not determined by the random
% splits of the k-folds

%crit =     criteria to optimize;
%consump =  optimization criterion;
%br =       base rate;
%it =       number of iterations; 


%run analyses 500 times
num_comb = combinations(size(crit,2));
cand_sum = zeros(num_comb,1);

for i = 1:it
    i
    %run the Opt_CV function to obtain results from each iteration of the
    %procedure while using k-fold cross-validation
    [insamp, insamp_prev, outsamp, outsamp_prev, ssubc] = Opt_CV(crit, consump, 1, 5, br);
    [candidate, indx_cand] = iscandidate(insamp_prev, br);
    cand_sum = cand_sum + candidate;
    insamp_mean_cohens(:,i) = nanmean(insamp,2);
    insamp_mean_prev(:,i) = nanmean(insamp_prev,2);
    outsamp_mean_cohens(:,i) = nanmean(outsamp,2);
    outsamp_mean_prev(:,i) = nanmean(outsamp_prev,2); 
end