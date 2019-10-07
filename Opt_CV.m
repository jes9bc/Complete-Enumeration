function [insamp_cohens, insamp_prev, outsamp_cohens, outsamp_prev, sols] = Opt_CV(crit, N3_DV, DVweight, k, br)
% This function uses k-fold cross-validation to provide the seperation of
% diagnostic clusters (using Cohen's d) for every possible diagnostic rule

%inputs:    crit = criteria; 
%           DV = optimization criterion/criteria
%           DVweight = weight placed on each of the DV
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

%disp('before first for loop');
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
%loop through number desired folds
scrit_holdout{k}=[];
sobj_holdout{k}=[];
sobj_holdout{k}=[];
topoverfold=[];
foldopt_id = [];
insampCohens = [];
alloutCohens = [];
withweight_ho{k} = [];
sumweight_ho{k} = [];
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
  sDV{i} = s{i}(:,data_p+1);
  sDV_holdout{i} = holdout{i}(:,data_p+1);
  %calculate the size and dim of the variables to optimize on
  [nDV{i},pDV{i}] = size(sDV{i});
  [nDV_ho{i},pDV_ho{i}] = size(sDV_holdout{i});
  %create empty weight vector to store input weights in matrix form
  DVweightvec=[];
  %create a matrix with the input weights repeated within vectors
  DVweightvec = repmat(DVweight, nDV{i},1);
  DVweightvec_ho=[];
  %create a matrix with the input weights repeated within vectors
  DVweightvec_ho = repmat(DVweight, nDV_ho{i},1);
  %apply desired weighting to variables on which we are optimizing
  withweight{i} = DVweightvec.*sDV{i};
  %sum across the columns of the N3_DV for optimization
  sumweight{i} = sum(withweight{i},2);
  %call the optimization procedure
  withweight_ho{i} = DVweightvec_ho.*sDV_holdout{i};
  sumweight_ho{i} = sum(withweight_ho{i},2);
  % Program which completes the complete enumeration
  [sobj{i}, ssubc{i}] = complete_enum(scrit{i},sumweight{i});
  [sobj_holdout{i}, ssubc{i}] = complete_enum(scrit_holdout{i},sumweight_ho{i});
  insamp_cohens(:,i) = sobj{i}(:,2);
  outsamp_cohens(:,i) = sobj_holdout{i}(:,2);
  
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

  %subset the N3_data with those only greater than or equal to an input base
  %rate
  n_sopt_ranks = size(sopt_ranks{i},2);
  sopt_baserate{i} = sopt_ranks{i}(sopt_ranks{i}(:,n_sopt_ranks-2)>= br,:);
  topoverfold = [topoverfold; sopt_baserate{i}(1,:)];
  foldopt_id =  [foldopt_id; topoverfold(i,23)];
  insampCohens = [insampCohens; topoverfold(i,2)];
  outofsampCohens = sobj_holdout{i}(foldopt_id(i),2);
  alloutCohens = [alloutCohens; outofsampCohens];

%                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
end

sols = ssubc{1};
[max_outCohens, indx_outCohens] = max(alloutCohens);
OptSol = foldopt_id(indx_outCohens);
toc
