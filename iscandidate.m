function [candidate, indx_cand] = iscandidate(obsprev, prev)
% iscandidate determines if the given rule is a candidate solution when
% there is a constraint placed, such as, the solution has to diagnosis at a
% given prevalence rate

candidate_all = obsprev>=prev;
candidatesum = sum(candidate_all, 2);
candidate = candidatesum>0;
indx_cand = find(candidatesum);
