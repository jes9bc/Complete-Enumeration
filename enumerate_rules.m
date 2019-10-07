function outRall = enumerate_rules(criteria)

[n,total]=size(criteria);
tot=0;
combos = combinations(total);
outRall = zeros(combos,total+1);

for items=1:total
    C = nchoosek(1:total,items);
    [setrows,setcols] = size(C);
    for j=1:setrows
        subdat = criteria(:,[C(j,:)]);
        for k=1:items
            tot = tot+1;
            outRall(tot,1:items) = [C(j,:)];
            outRall(tot,total+1) = k;
        end         
    end
end