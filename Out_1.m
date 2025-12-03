clear
T = 4000;
LOF = 45;   % Loss of Fertility Age
q_star = 0; % Paternity uncertainty
IndVec = 1:0.25:10;
LVec = 10:50;

% Create parameter combinations
[paramI, paramJ] = ndgrid(1:length(IndVec), 1:length(LVec));
paramPairs = [paramI(:), paramJ(:)];
N = size(paramPairs, 1);

% Preallocate temporary storage as cells
TP_temp = cell(N, 1);
PAT_temp = cell(N, 1);

%Start parallel pool (optional)
if isempty(gcp('nocreate'))
    parpool(64);  
end 

parfor idx = 1:N
    i = paramPairs(idx, 1);
    j = paramPairs(idx, 2);

    Ind = IndVec(i);
    L = LVec(j);
    FSM = (L / 2.5) + 2;
    MSM = 15;
    chi = 0;

    [EndTotals, Paternities] = Middle(Ind, FSM, MSM, LOF, L, T, q_star, chi);
    TP_temp{idx} = EndTotals;
    PAT_temp{idx} = Paternities;
end

TPArray = zeros(length(LVec), 20, length(IndVec));
PATArray = zeros(length(LVec), 6, T+1, length(IndVec));

for n = 1:N
    i = paramPairs(n, 1);
    j = paramPairs(n, 2);
    TPArray(j, :, i) = TP_temp{n}';
    PATArray(j, :, :, i) = PAT_temp{n};
end

save('Out_1.mat', 'TPArray', 'PATArray', 'IndVec', 'LVec', 'T');
zip('Out_1.zip', 'Out_1.mat');
