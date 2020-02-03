function[obj_function, outRall] = cons_opt_mahal(criteria,composite)

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
            m1 = mean(composite(diagnose==1,:));
            m2 = mean(composite(diagnose==0,:));
            mDiff = m1-m2;
            n1 = sum(diagnose==1);
            n2 = sum(diagnose==0);
            c1 = cov(composite(diagnose==1,:));
            c2 = cov(composite(diagnose==0,:));
            pC = ((n1/(n1+n2))*c1)+((n2/(n1+n2))*c2);
            mahal_d = sqrt(mDiff*inv(pC)*mDiff');
            obj_function = [obj_function;[0 mahal_d 0 n1 n2 m1 m2]];
            outRall(tot,1:items) = [C(j,:)];
            outRall(tot,total+1) = k;
        end         
    end
end