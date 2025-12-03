function[FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM,X,Xg,Xm,JMm,JGm,JMf,JGf,MP,GP]=...
    AgingMaturation(q_star,FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM,X,Xg,Xm,JMm,JGm,JMf,JGf)
%created Wednesday, January 29 2025---20 populations
%Maturation First
%Last col-children @ end of dependancy
mature_M = sum(FMm(:,end))+sum(FGm(:,end))+sum(sum(PMm(:,:,end)))+sum(Xm(:,end));
mature_G = sum(FGg(:,end))+sum(FMg(:,end))+sum(sum(PGg(:,:,end)))+sum(sum(PMg(:,:,end)))+sum(Xg(:,end));
%%Paternity theft of G offspring by M males

if (sum(M) + sum(G)) < 1
    q = (sum(M)/(sum(M)+sum(G)+ 1))*q_star;
else
    q = sum(M)/(sum(M)+sum(G))*q_star;
end

theft = binornd(mature_G,q);
mature_G = mature_G - theft;
mature_M = mature_M + theft;

M_Females = binornd(mature_M,0.5);  %equal chance of each type
G_Females = binornd(mature_G,0.5);
M_Males = mature_M - M_Females;
G_Males = mature_G - G_Females;

%Aging of full population
JMm(2:end) = JMm(1:end-1);
JMm(1) = M_Males;
JGm(2:end) = JGm(1:end-1);
JGm(1) = G_Males;
JMf(2:end) = JMf(1:end-1);
JMf(1) = M_Females;
JGf(2:end) = JGf(1:end-1);
JGf(1) = G_Females;

FM(2:end) = FM(1:end-1) + FMm(1:end-1,end) + FMg(1:end-1,end);
FM(1) = JMf(end);  %

FG(2:end) = FG(1:end-1) + FGm(1:end-1,end) + FGg(1:end-1,end);
FG(1) = JGf(end);  %

M(2:end) = M(1:end-1);    %Shift M males down 1 time step and add maturing males
M(1) = JMm(end);

G(2:end) = G(1:end-1)+PM(end,1:end-1)'+PG(end,1:end-1)'+...
    sum(PGg(end,1:end-1,:),3)'+sum(PMm(end,1:end-1,:),3)'+...
    sum(PMg(end,1:end-1,:),3)'; %Shift G males 
G(1) = JGm(end); %add maturing males


X(2:end)=X(1:end-1)+Xm(1:end-1,end)+Xg(1:end-1,end);
X(1)= FM(end) + FG(end)+ FMm(end,end) + FGg(end,end) + FGm(end,end) + ...
    FMg(end,end) + sum(PG(end,:)) + sum(PM(end,:)) + ...
    sum(PMm(end,:,end)) + sum(PMg(end,:,end)) + sum(PGg(end,:,end));

Xm(2:end,2:end) = Xm(1:end-1,1:end-1); %Shift Xm Females down 1 time step
Xm(1,:) = 0;
Xm(:,1) = 0;
Xm(1,1:end-1) = FMm(end,1:end-1) + FGm(end,1:end-1) + squeeze(sum(PMm(end,:,1:end-1),2))';

Xg(2:end,2:end) = Xg(1:end-1,1:end-1); %Shift Xg Females down 1 time step and add maturing males
Xg(1,:) = 0;
Xg(:,1) = 0;
Xg(1,1:end-1) = FGg(end,1:end-1) + FMg(end,1:end-1) + squeeze(sum(PMg(end,:,1:end-1),2))'...
    +squeeze(sum(PGg(end,:,1:end-1),2))';

%remove 1 col of females and 1 row of males for both P and Pg...
%Pg--add last submatrix of same.....Pg-->P due to maturity
PG(2:end,2:end) = PG(1:end-1,1:end-1) + PGg(1:end-1,1:end-1,end);
PG(1,:) = 0;  %zero out first row and column to prepare for pairing again (no maturation here)
PG(:,1) = 0;

PM(2:end,2:end) = PM(1:end-1,1:end-1) + PMm(1:end-1,1:end-1,end) + ...
                  PMg(1:end-1,1:end-1,end);
PM(1,:) = 0;  %zero out first row and column to prepare for pairing again (no maturation here)
PM(:,1) = 0;

PMm(2:end,2:end,2:end) = PMm(1:end-1,1:end-1,1:end-1);
PMm(1,:,:) = 0;
PMm(:,1,:) = 0;
PMm(:,:,1) = 0;

PMg(2:end,2:end,2:end) = PMg(1:end-1,1:end-1,1:end-1);
PMg(1,:,:) = 0;
PMg(:,1,:) = 0;
PMg(:,:,1) = 0;

PGg(2:end,2:end,2:end) = PGg(1:end-1,1:end-1,1:end-1);
PGg(1,:,:) = 0;
PGg(:,1,:) = 0;
PGg(:,:,1) = 0;

FMm(2:end,2:end) = FMm(1:end-1,1:end-1); %shift down
FMm(1,:) = 0;
FMm(:,1) = 0;

FMg(2:end,2:end) = FMg(1:end-1,1:end-1); %shift down
FMg(1,:) = 0;
FMg(:,1) = 0;

FGm(2:end,2:end) = FGm(1:end-1,1:end-1); %shift down
FGm(1,:) = 0;
FGm(:,1) = 0;

FGg(2:end,2:end) = FGg(1:end-1,1:end-1); %shift down
FGg(1,:) = 0;
FGg(:,1) = 0;

MP = M_Females + M_Males;
GP = G_Females + G_Males;
end