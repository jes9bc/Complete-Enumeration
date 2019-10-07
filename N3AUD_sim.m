% The following code was used in the Simulation section under Demonstration
% in the manuscript

load('criteria')

[n,p_crit]=size(criteria);
numcomb = combinations(p_crit);
outRall = enumerate_rules(criteria);

iter = 500;
overlap = [0 .1 .2 .3 .4];

results=[];
for i=1:iter
    for o = 1:length(overlap)
        % generate the derivation variable from the criteria and overlap
        [OptCrit, pos, true_crit, thresh] = genDerivationVar(outRall,criteria,overlap(o));
        tic
        OptCrit_t = OptCrit';
        % Since there is no constraint on the prevalance rate in the
        % simulation the br parameter is set to .00001
        [insamp_cohens, insamp_prev, outsamp_cohens, outsamp_prev, sols] = Opt_CV(criteria, OptCrit_t, 1, 5, .00001);
        mean_outsamp_cohens = mean(outsamp_cohens,2);
        maxoutcohens = max(mean_outsamp_cohens);
        ob_pos = find(mean_outsamp_cohens==maxoutcohens)
        truemax = mean_outsamp_cohens(pos);
        
        results = [results; i o pos ob_pos truemax maxoutcohens true_crit thresh];
        
    end

end
results2 = results;
opt_simulation = results;

