clear
T=800;
LOF = 45;   %Loss of Fertility Age b 
q_star = 0; %Paternity uncertainty
IndVec=1:.25:10;
LVec = 10:50;
R=1;
for R = 1:1
for i = 1:length(IndVec)
    Ind = IndVec(i);
    for j = 1:length(LVec)
    L = LVec(j);
    FSM = L/(2.5)+2;
    MSM = 15;
    chi = 0;                               
    [EndTotals,Paternities]=Middle_Expanded(Ind,FSM,MSM,LOF,L,T,q_star,chi);
     TP(j,:) = EndTotals';
     PAT(j,:) = Paternities;
    end
    TPArray(:,:,i) = TP;
    PATArray(:,:,i) = PAT;
end
TCell{R}=TPArray;
PCell{R}=PATArray;
R = R+1;
end