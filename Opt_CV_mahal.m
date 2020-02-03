function [insamp_mahal, insamp_prev, outsamp_mahal, outsamp_prev, sols] = Opt_CV_mahal(crit, N3_DV, k, br)
% This function uses k-fold cross-validation to provide the seperation of
% diagnostic clusters (using Mahalanobis' distance) for every possible diagnostic rule

%inputs:    crit = criteria; 
%           DV = optimization criterion/criteria
%           k = number of folds for cross-validation purposes
%           br = baserate - smallest percentage diagnosised in each test
%           fold

tic
[data_n, data_p] = size(crit);
% N_rand is used to create k non-overlapping folds
N_rand = randi([1 k],data_n,1);
alldata = [crit N3_DV N_rand];
[nDVo,pDVo] = size(N3_DV);

numcombos = combinations(data_p);
d_rank = (1:numcombos)';


s{k}=[];
sn{k}=[];
sp{k}=[];
sn_ho{k}=[];
sp_ho{k}=[];
scrit{k}=[];
sDV{k}=[];
nDV{k}=[];
pDV{k}=[];
withweight{k}=[];
sumweight{k}=[];
sobj{k}=[];
ssubc{k}=[];
sprev{k}=[];
sneeded{k}=[];
sneeded_copy{k}=[];
ssortd{k}=[];
sindex_sortd{k}=[];
sopt_ranks{k}=[];
sopt_baserate{k}=[];
holdout{k}=[];
scrit_holdout{k}=[];
sobj_holdout{k}=[];
sobj_holdout{k}=[];
topoverfold=[];
foldopt_id = [];
insampMahal = [];
alloutMahal = [];
minrankall = max(d_rank);
sDV_holdout{k}=[];

for i=1:k
  %create folds
  s{i} = alldata(alldata(:,end)~=i,:);
  holdout{i} = alldata(alldata(:,end)==i,:);
  %save size of desired folds
  [sn{i}, sp{i}] = size(s{i});
  [sn_ho{i}, sp_ho{i}] = size(holdout{i});
  %seperate out criteria
  scrit{i} = s{i}(:,1:data_p);
  scrit_holdout{i} = holdout{i}(:,1:data_p);
  %Variables to optimize on within folds - N3_DV should start at variable 14
  %and continues until p-1
  sDV{i} = s{i}(:,data_p+1:end-1);
  sDV_holdout{i} = holdout{i}(:,data_p+1:end-1);
  %calculate the size and dim of the variables to optimize on
  [nDV{i},pDV{i}] = size(sDV{i});
  [nDV_ho{i},pDV_ho{i}] = size(sDV_holdout{i});

  [sobj{i}, ssubc{i}] = cons_opt_mahal(scrit{i},sDV{i});
  [sobj_holdout{i}, ssubc_holdout{i}] = cons_opt_mahal(scrit_holdout{i},sDV_holdout{i});
  insamp_mahal(:,i) = sobj{i}(:,2);
  outsamp_mahal(:,i) = sobj_holdout{i}(:,2);
  %calculate base rates
  sprev{i} = sobj{i}(:,4)/sn{i};
  insamp_prev(:,i) = sprev{i};
  outsamp_prev(:,i) = sobj_holdout{i}(:,4)/sn_ho{i};
  %create matrix of needed variables
  sneeded{i} = [sobj{i} ssubc{i} sprev{i}];
  %create a copy of the variables that are needed
  sneeded_copy{i} = sneeded{i};
  %sort by Cohen's D from maximum to minimum values
  [ssortd{i}, sindex_sortd{i}] = sortrows(sneeded_copy{i}, -2);
  %create matrix of sorted needed variables with ranks saved
  
  sopt_ranks{i} = [ssortd{i} sindex_sortd{i} d_rank];
  [n_sopt, p_sopt] = size(sopt_ranks{i});

  %subset the crit with those only greater than or equal to an input base
  %rate
  n_sopt_ranks = size(sopt_ranks{i},2);
  sopt_baserate{i} = sopt_ranks{i}(sopt_ranks{i}(:,p_sopt-2)>= br,:);
  topoverfold = [topoverfold; sopt_baserate{i}(1,:)];
  foldopt_id =  [foldopt_id; topoverfold(i,p_sopt-1)];
  insampMahal = [insampMahal; topoverfold(i,2)];
  outofsampMahal = sobj_holdout{i}(foldopt_id(i),2);
  alloutMahal = [alloutMahal; outofsampMahal];
%disp('first for loop'); disp(i);
end
%allranksmean = mean(allranks,2);
% allsol = sortbyindex{1}(:,10:21);
% ranks_cv = allranks;
% prevrates_cv = prevrates_cv;
% Mahal_cv = Mahald;
sols=ssubc{1};
[max_outMahal, indx_outMahal] = max(alloutMahal);
OptSol = foldopt_id(indx_outMahal);
toc
