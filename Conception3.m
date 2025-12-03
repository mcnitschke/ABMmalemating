function[FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM, MPat,GPat,TGP,TMP] = ...
    Conception3(FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM,PC,FertileVec)
%Created Wednesday January, 29 2025
%input subpopulations, probability of conception and fertility index (ages)
%Determine all conceptions first, then decide who mates with whom

FGconceive = binornd(FG,PC);
FMconceive = binornd(FM,PC);
PMconceive = binornd(PM,PC);
PGconceive = binornd(PG,PC);

FG = FG - FGconceive;
FM = FM - FMconceive;
PM = PM - PMconceive;
PG = PG - PGconceive;
PMmconceive = binornd(PMconceive,0.5);
PMgconceive = PMconceive - PMmconceive;
PGg(:,:,1) = PGg(:,:,1) + PGconceive;
PMm(:,:,1) = PMm(:,:,1) + PMmconceive;
PMg(:,:,1) = PMg(:,:,1) + PMgconceive;

MPat = 0;
GPat = 0;

GStart = G;

%---Mating-----
%For each year of female fertility (j) I am running through each of that
%number of females....k (k goes from 1 to "number of F of age j)

% Step 1: Create a list of all conceiving females
femaleList = [];
for j = 1:length(FertileVec)
    femaleList = [femaleList; repmat([j, 1], FMconceive(j), 1)];  % FM = 1
    femaleList = [femaleList; repmat([j, 2], FGconceive(j), 1)];  % FG = 2
end

% Step 2: Shuffle for fairness
femaleList = femaleList(randperm(size(femaleList,1)), :);

% Step 3: Loop over shuffled females
for i = 1:size(femaleList,1)
    j = femaleList(i,1);
    sexType = femaleList(i,2);  % 1=FM, 2=FG

    TotalM = sum(M);
    TotalG = sum(G);

    if (TotalM + TotalG) > 0
        Weight = [TotalM / (TotalM + TotalG), TotalG / (TotalM + TotalG)];

        if randsample(2,1,true,Weight) == 1
            % Mate with M-male
            if sexType == 1
                FMm(j,1) = FMm(j,1) + 1;
            else
                if rand <= 0.5
                    FGm(j,1) = FGm(j,1) + 1;
                else
                    FGg(j,1) = FGg(j,1) + 1;
                end
            end
            MPat = MPat + 1;

        else
            % Mate with G-male
            mate = randi(TotalG);
            mindex = sum(cumsum(G) < mate) + 1;
            G(mindex) = G(mindex) - 1;

            if sexType == 1
                if rand <= 0.5
                    PMm(j,mindex,1) = PMm(j,mindex,1) + 1;
                else
                    PMg(j,mindex,1) = PMg(j,mindex,1) + 1;
                end
            else
                PGg(j,mindex,1) = PGg(j,mindex,1) + 1;
            end
            GPat = GPat + 1;
        end
    end
end

TMP = MPat;
TGP = GPat;

if sum(M)>=1
    MPat = MPat/sum(M);
else
    MPat = MPat;
end

if (sum(G)+sum(sum(PM))+sum(sum(PG))) >= 1
    GPat = GPat/sum(GStart);
else
    GPat = GPat;
end