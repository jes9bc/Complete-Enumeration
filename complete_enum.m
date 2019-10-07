function[obj_function, outRall] = complete_enum(criteria,composite)
% 

obj_function=[];

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
            diagnose = sum(subdat,2) >= k;
            m1 = mean(composite(diagnose==1));
            m2 = mean(composite(diagnose==0));
            n1 = sum(diagnose==1);
            n2 = sum(diagnose==0);
            v1 = var(composite(diagnose==1));
            v2 = var(composite(diagnose==0));
            stderror = sqrt(v1/n1 + v2/n2);
            t = (m1 - m2)/stderror;
            spooled = sqrt(((n1 - 1)*v1 + (n2 - 1)*v2)/(n1 + n2));
            d = (m1 - m2)/spooled;
            dprime = (m1 - m2)/sqrt(v2);
            obj_function = [obj_function;[t d dprime n1 n2 m1 m2 v1 v2]];
            outRall(tot,1:items) = [C(j,:)];
            outRall(tot,total+1) = k;
        end         
    end
end