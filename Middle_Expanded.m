function[EndTotals,Paternities]=Middle_Expanded(Ind, FSM, MSM, LOF, L, T, q_star, chi)
dt = 1;   %time step (years)

A =100; %Maximum Age (years)
CAP =500000; %Carrying Capacity
MLOF =min((2.05)*L,75);

delta_f = 1/L;  %Adult female death rate
delta_m = (1.09)/L; %Adult male death rate
delta_d = 0.08;  %Dependant death rate
delta_j = 1/L; %Juvenile death rate


%Initialize
TimeVec = 0:dt:T;  %Full time horizon vector (evolutionary)
AgeVec = 0:dt:A;  %Time hoizon for each individual
MaleVec = AgeVec(AgeVec>=MSM&AgeVec<MLOF); %Adult time horizonn (Males)
DepVec = AgeVec(AgeVec<Ind);    %Dependant time horizon
FertileVec = AgeVec(AgeVec>=FSM&AgeVec<LOF); %fertility horizon (Females)
PostFertileVec=AgeVec(AgeVec>=LOF); %Post Fertile Horizon
MaleJuvVec = AgeVec(AgeVec>=Ind & AgeVec<MSM);
FemJuvVec = AgeVec(AgeVec>=Ind & AgeVec<FSM);

FM = zeros(length(FertileVec),1);                        %FM females
FG = zeros(length(FertileVec),1);                        %FG females
M = zeros(length(MaleVec),1);                       %M males
G = zeros(length(MaleVec),1);                       %G males
FMm= zeros(length(FertileVec),length(DepVec)); %M Females with m child
FGg= zeros(length(FertileVec),length(DepVec)); %G Females with g child
FGm= zeros(length(FertileVec),length(DepVec)); %G Females with m child
FMg= zeros(length(FertileVec),length(DepVec)); %M Felames with g child
PGg = zeros(length(FertileVec),length(MaleVec),length(DepVec));%Pairs with G male children
PG = zeros(length(FertileVec),length(MaleVec));
PMm = zeros(length(FertileVec),length(MaleVec),length(DepVec));%Pairs with G male children
PMg = zeros(length(FertileVec),length(MaleVec),length(DepVec));%Pairs with G male children
PM = zeros(length(FertileVec),length(MaleVec));
X = zeros(length(PostFertileVec),1);
Xg = zeros(length(PostFertileVec),length(DepVec));
Xm = zeros(length(PostFertileVec),length(DepVec));
JMm = zeros(length(MaleJuvVec),1);
JGm = zeros(length(MaleJuvVec),1);
JMf = zeros(length(FemJuvVec),1);
JGf = zeros(length(FemJuvVec),1);

%Non-constant conception rate
% % rho =6/(L+8).*FertileVec;
% rho = (.9/5).*FertileVec - (.9*L+1)/10;
% rho(rho>3)=3;
% rho(end-6:end) = 135/7-3/7.*FertileVec(end-6:end);
% rho(rho<0) = .01;
rho = 3;

%Event Probabilities
PFD = 1-exp(-delta_f*dt);  %probability of adult female death
PMD= 1-exp(-delta_m*dt);   %probability of adult male death
PJD = 1-exp(-delta_j*dt);  %probability of juvenile death
PDD = 1-exp(-delta_d*dt);  %probability of dependant death
PC  = 1-exp(-rho*dt);      %probabilit of a conception

%Preallocate Totals  
Totals = zeros(20,length(TimeVec));
MPI = zeros(1,length(TimeVec));
GPI = zeros(1,length(TimeVec));
GPT = zeros(1,length(TimeVec));
MPT = zeros(1,length(TimeVec));

FM(1) = 125000;
FG(1) = 125000;
 M(1) = 125000;
 G(1) = 125000;

for t = 2:length(TimeVec)

[FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM,X,Xg,Xm,JMm,JGm,JMf,JGf]=...
    Death(FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM,X,Xg,Xm,JMm,JGm,JMf,JGf,PFD,PMD,PJD,PDD);

[FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM,X,Xg,Xm,JMm,JGm,JMf,JGf,MP,GP]=...
    AgingMaturation(q_star,FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM,X,Xg,Xm,JMm,JGm,JMf,JGf);

[FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM, MPat,GPat,TGP,TMP]= ...
    Conception(FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM,PC,FertileVec);

[FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM]...
    =Breakup(FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM,chi);

[FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM,X,Xg,Xm,JMm,JGm,JMf,JGf]=...
    CarryingCapacity(FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM,X,Xg,Xm,JMm,JGm,JMf,JGf,CAP);

Totals(1,t)  = sum(FM);
Totals(2,t)  = sum(FG);
Totals(3,t)  = sum(M);
Totals(4,t)  = sum(G);
Totals(5,t)  = sum(sum(FMm));
Totals(6,t)  = sum(sum(FGg));
Totals(7,t)  = sum(sum(FGm));
Totals(8,t)  = sum(sum(FMg));
Totals(9,t)  = sum(sum(sum(PGg)));
Totals(10,t) = sum(sum(PG));
Totals(11,t) = sum(sum(sum(PMm)));
Totals(12,t) = sum(sum(sum(PMg)));
Totals(13,t) = sum(sum(PM));
Totals(14,t) = sum(X);
Totals(15,t) = sum(sum(Xg));
Totals(16,t) = sum(sum(Xm));
Totals(17,t) = sum(sum(JMm));
Totals(18,t) = sum(sum(JGm));
Totals(19,t) = sum(sum(JMf));
Totals(20,t) = sum(sum(JGf));
% TotalG(t) = GGuard;

MPT(t) = MP;
GPT(t) = GP;
MPI(t) = MPat;
GPI(t) = GPat;
MPTT(t) = TMP;
GPTT(t) = TGP;
end
EndTotals = Totals(:,end);
Paternities = [MPT; GPT; MPI; GPI; MPTT; GPTT];
end