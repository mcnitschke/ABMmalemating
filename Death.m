function[FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM,X,Xg,Xm,JMm,JGm,JMf,JGf]...
 = Death(FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM,X,Xg,Xm,JMm,JGm,JMf,JGf,PFD,PMD,PJD,PDD)
%created Wednesday, January 29 2025
%%%%%%
%Females
%
    %Female Survivors
    FM = binornd(FM,1-PFD);
    FG = binornd(FG,1-PFD);
    FMm = binornd(FMm,1-PFD);
    FGg = binornd(FGg,1-PFD);
    FGm = binornd(FGm,1-PFD);
    FMg = binornd(FMg,1-PFD);
    X = binornd(X,1-PFD);
    Xg=binornd(Xg,1-PFD);
    Xm=binornd(Xm,1-PFD);

    %Paired Deaths and changeovers
    PGg_F_deaths = binornd(PGg, PFD);
    PG_F_deaths = binornd(PG,PFD);
    PMm_F_deaths = binornd(PMm,PFD);
    PMg_F_deaths = binornd(PMg,PFD);
    PM_F_deaths = binornd(PM,PFD);

    PGg = PGg - PGg_F_deaths;
    PG = PG - PG_F_deaths;
    PMm = PMm - PMm_F_deaths;
    PMg = PMg - PMg_F_deaths;
    PM = PM - PM_F_deaths;

    G = G + sum(sum(PGg_F_deaths,3))' + sum(sum(PMm_F_deaths,3))' +...
        sum(sum(PMg_F_deaths,3))' + sum(PG_F_deaths)' + sum(PM_F_deaths)';
    %Pg-->G, P-->G
    %Pg has 3 dimensions, P has 2...in both cases, summing all females for
    %any given male age...thus adding to G!
    %two sums as we sum the females at different stages of dependant
    %care...Pg is a 3D array 3rd dimension = children, 1st dim = women
    %Double sum is a column of numbers...only need females/don't need kids

%Males
%
    %Male Survivors in this time unit
    M = binornd(M,1-PMD);
    G = binornd(G,1-PMD);

    %Paired Deaths and changeover
    PGg_M_deaths = binornd(PGg,PMD);
    PG_M_deaths  = binornd(PG,PMD);
    PMm_M_deaths = binornd(PMm,PMD);
    PMg_M_deaths = binornd(PMg,PMD);
    PM_M_deaths  = binornd(PM,PMD);

    PGg = PGg - PGg_M_deaths;
    PG = PG - PG_M_deaths;
    PMm = PMm - PMm_M_deaths;
    PMg = PMg - PMg_M_deaths;
    PM = PM - PM_M_deaths;

    FGg = FGg + squeeze(sum(PGg_M_deaths,2)); 
    FMm = FMm + squeeze(sum(PMm_M_deaths,2));
    FMg = FMg + squeeze(sum(PMg_M_deaths,2));
    FM  = FM  + sum(PM_M_deaths,2);
    FG  = FG  + sum(PG_M_deaths,2);

%Juveniles
    JMm = binornd(JMm,1-PJD);  %Survivors
    JGm = binornd(JGm,1-PJD);  %h 
    JMf = binornd(JMf,1-PJD);
    JGf = binornd(JGf,1-PJD);

%Dependants
%
    %Survivors are already accounted for above
    %Deaths and changeovers
    FMm_D_Deaths = binornd(FMm,PDD);
    FGg_D_Deaths = binornd(FGg,PDD);
    FGm_D_Deaths = binornd(FGm,PDD);
    FMg_D_Deaths = binornd(FMg,PDD);
    PGg_D_Deaths = binornd(PGg,PDD);
    PMm_D_Deaths = binornd(PMm,PDD);
    PMg_D_Deaths = binornd(PMg,PDD);
    Xg_D_Deaths = binornd(Xg,PDD);
    Xm_D_Deaths = binornd(Xm,PDD);

    FMm = FMm - FMm_D_Deaths;  %Females who lose dependants
    FGg = FGg - FGg_D_Deaths;
    FGm = FGm - FGm_D_Deaths;
    FMg = FMg - FMg_D_Deaths;
    FG = FG + sum(FGg_D_Deaths,2) + sum(FGm_D_Deaths,2);
    FM = FM + sum(FMm_D_Deaths,2) + sum(FMg_D_Deaths,2);

    PGg = PGg - PGg_D_Deaths;   %Pg --> P
    PMm = PMm - PMm_D_Deaths;
    PMg = PMg - PMg_D_Deaths;

    PG = PG + sum(PGg_D_Deaths,3);
    PM = PM + sum(PMm_D_Deaths,3) + sum(PMg_D_Deaths,3);

    Xm = Xm - Xm_D_Deaths;
    Xg = Xg -Xg_D_Deaths;
    X = X + sum(Xm_D_Deaths,2) + sum(Xg_D_Deaths,2);
end