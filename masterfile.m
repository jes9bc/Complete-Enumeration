% This file demonstrates how results were obtained in the manuscript titled
% Combinatorial Optimization of Classification Decisions: An Application to
% Refine Psychiatric Diagnoses

% To obtain the NESARC-III Alcohol Use Disorder symptoms that were used in
% this manuscript, a DUA can be requested. To request data, please refer to
% the following link: https://www.niaaa.nih.gov/sites/default/files/procedures_for_obtaining_datasets_vbw_edited_Final_4_23_2019.pdf

% Read in data - after proof of a DUA is provided, the author can be
% contacted at jes9bc@mail.missouri.edu for access to the following file,
% which will read in the data in the necessary format
read_N3_AUD

%create dataset
fulldata = [idnum tolpy cutdpy morelngpy lotspy giveuppy hprobpy cravepy withdrpy rolintpy hazpy sprobpy NAGE sf_nonagebias behav N2AQ2 N2AQ3];
% delete missing values
fulldata(any(isnan(fulldata),2),:) = [];

% Optimization of criteria was performed on individuals who have had at
% least 12 drinks in the past year and who are at least 21 years of age
N3Consump_12dpy = fulldata(fulldata(:,16)==1,:);
data0 = N3Consump_12dpy(N3Consump_12dpy(:,13)>=21,:);

% A diagnostic base-rate of 10% was used as a constraint to obtain a
% cluster of individuals with a moderate of above AUD (base-rate informed
% by a diagnosis under the DSM-5)
br = .1;
% it = the number of iterations that the program should be executed
it = 500;

% Define the "clustering" variables
criteria = data0(:,2:12);
% The criteria dataset will be used in the simulation
save('criteria')
% Define the "derivation" variable
consump = data0(:,15);

% Call the program opt_results to obtain results from the cross-validation
% across all 500 iterations
[insamp_cohens, insamp_prev, outsamp_cohens, outsamp_prev, sum_miss] = opt_mult_it(criteria, consump, br, it);

% The program combiantions will provide the number of possible
% diagnostic rules with the number of symptoms input
numbcomb = combinations(11);
opt_index = [1:numbcomb]';

% summary statistics
N3_insamp_mean_cohens = mean(insamp_cohens,2);
N3_insamp_mean_prev = mean(insamp_prev,2);
N3_outsamp_mean_cohens = mean(outsamp_cohens,2);
N3_outsamp_mean_prev = mean(outsamp_prev,2);
N3_full_summary = [N3_insamp_mean_cohens  N3_insamp_mean_prev  N3_outsamp_mean_cohens  N3_outsamp_mean_prev  sum_miss];

save('N3_full_summary');

% get completely enumerated diagnostic criteria profiles
outRall = enumerate_rules(criteria);

N3_ind_cand = [opt_index N3_full_summary outRall];
% sort descending by out of sample cohens's d
N3_ind_sort = sortrows(N3_ind_cand, -4);
%rank solutions by performance according to out of sample cohen's d
N3_sort_rank = [N3_ind_sort opt_index];
N3_withrankings = sortrows(N3_sort_rank, 1);
N3_withrankings_nozero = N3_withrankings;
% Ensure samples are a candidate solution in at least 1 iteration
N3_withrankings_nozero(N3_withrankings_nozero(:,6)==0,:)=[];
N3_cand = N3_full_summary;
N3_cand(N3_cand(:,5)==0,:)=[];
% maximum out of sample cohen's d
N3_max = max(N3_cand(:,3));
% optimal solution index
N3_opt = find(N3_full_summary(:,3)==N3_max);




