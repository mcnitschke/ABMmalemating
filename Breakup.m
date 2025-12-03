function[FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM]...
    =Breakup(FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM,chi)
%created Thursday, January 30 2025
 
PGbu = binornd(sum(sum(PG)),chi);         % Total number of PG breakups
PMbu = binornd(sum(sum(PM)),chi);         % Total number of PM breakups
PGgbu = binornd(sum(sum(sum(PGg))),chi);  % Total number of PGg breakups
PMmbu = binornd(sum(sum(sum(PMm))),chi);  % Total number of PMm breakups
PMgbu = binornd(sum(sum(sum(PMg))),chi);  % Total number of PMg breakups

if PGbu>0

for i = 1:PGbu
    
    indPG = find(PG);  
    [PGa,PGb] = ind2sub(size(PG),indPG);
    PG(PGa(end),PGb(end)) = PG(PGa(end),PGb(end)) - 1;
    FG(PGa(end)) = FG(PGa(end)) +1;
    G(PGb(end)) = G(PGb(end)) + 1;
end
end

if PMbu>0

for i = 1:PMbu

    indPM = find(PM);  
    [PMa,PMb] = ind2sub(size(PM),indPM);
    PM(PMa(end),PMb(end)) = PM(PMa(end),PMb(end)) - 1;
    FM(PMa(end)) = FM(PMa(end)) +1;
    G(PMb(end)) = G(PMb(end)) + 1;
end
end

if PGgbu >0

for i = 1:PGgbu
    indPGg = find(PGg);  
    [PGga,PGgb,PGgc] = ind2sub(size(PGg),indPGg);
    PGg(PGga(end),PGgb(end),PGgc(end)) = PGg(PGga(end),PGgb(end),PGgc(end)) - 1;
    FGg(PGga(end),PGgc(end)) = FGg(PGga(end),PGgc(end)) +1;
    G(PGgb(end)) = G(PGgb(end)) + 1;

end
end

if PMmbu >0

for i = 1:PMmbu
    indPMm = find(PMm);  
    [PMma,PMmb,PMmc] = ind2sub(size(PMm),indPMm);
    PMm(PMma(end),PMmb(end),PMmc(end)) = PMm(PMma(end),PMmb(end),PMmc(end)) - 1;
    FMm(PMma(end),PMmc(end)) = FMm(PMma(end),PMmc(end)) +1;
    G(PMmb(end)) = G(PMmb(end)) + 1;

end
end


if PMgbu >0

for i = 1:PMgbu
    indPMg = find(PMg);  
    [PMga,PMgb,PMgc] = ind2sub(size(PMg),indPMg);


    PMg(PMga(end),PMgb(end),PMgc(end)) = PMg(PMga(end),PMgb(end),PMgc(end)) - 1;
    FMg(PMga(end),PMgc(end)) = FMg(PMga(end),PMgc(end)) +1;
    G(PMgb(end)) = G(PMgb(end)) + 1;

end
end


end