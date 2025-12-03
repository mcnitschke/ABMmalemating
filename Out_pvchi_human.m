clear
T = 2500;
LOF = 45;   % Loss of Fertility Age
Ind = 3;
L = 38;
FSM = (L / 2.5) + 2;
MSM = 15;

qvec = 0:0.0025:0.1;
% chivec =1:-.02:0;
chivec = 1./(1:50);
chi_new = (chivec-min(chivec))/(max(chivec)-min(chivec));


% Create parameter grid
[paramI, paramJ] = ndgrid(1:length(qvec), 1:length(chivec));
paramPairs = [paramI(:), paramJ(:)];
N = size(paramPairs, 1);

% Preallocate cell arrays for results
TP_temp = cell(N, 1);
PAT_temp = cell(N, 1);

% Optional: parallel pool
% if isempty(gcp('nocreate'))
%     parpool(64); 
% end

for idx = 1:N
    i = paramPairs(idx, 1);
    j = paramPairs(idx, 2);

    q_star = qvec(i);
    chi = chi_new(j);

    [EndTotals, Paternities] = Middle(Ind, FSM, MSM, LOF, L, T, q_star, chi);
    TP_temp{idx} = EndTotals;
    PAT_temp{idx} = Paternities;
end

% Reorganize into arrays
TPArray = zeros(length(qvec), 20, length(chivec));
PATArray = zeros(length(qvec), 6, T+1, length(chivec));  % Assuming full time series is returned

for n = 1:N
    i = paramPairs(n, 1);
    j = paramPairs(n, 2);
    TPArray(i, :, j) = TP_temp{n}';
    PATArray(i, :, :, j) = reshape(PAT_temp{n},[1,6,T+1]);
end

% Save and compress
save('Out_pvchi_human_mod.mat', 'TPArray', 'PATArray', 'qvec', 'chivec', 'T');
zip('Out_pvchi_human_mod.zip', 'Out_pvchi_human_mod.mat');
