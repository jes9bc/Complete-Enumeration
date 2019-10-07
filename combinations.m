function test = combinations(numcrit)
% This program will provide the number of possible
% diagnostic rules with the number of symptoms input

% input: numcrit = the total number of symptoms for the diagnosis that is
% being optimized

first = numcrit*(2^(numcrit)-1);
totalsum = 0;
for j = 1:numcrit-1
    totalnum = nchoosek(numcrit,j);
    deleted = totalnum*(numcrit-j);
    totalsum = totalsum + deleted;
end
test = first-totalsum;