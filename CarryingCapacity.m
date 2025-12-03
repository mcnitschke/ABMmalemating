function[FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM,X,Xg,Xm,JMm,JGm,JMf,JGf]...
  =CarryingCapacity(FM,FG,M,G,FMm,FGg,FGm,FMg,PGg,PG,PMm,PMg,PM,X,Xg,Xm,JMm,JGm,JMf,JGf,CAP)

%Created Wednesday 29 January, 2025
%No maximum age...Randomly remove a quantity of individulals over the CAP
Total = zeros(20,1);
Total(1) = sum(FM);
Total(2) = sum(FG);
Total(3) = sum(M);
Total(4) = sum(G);
Total(5) = sum(sum(FMm));
Total(6) = sum(sum(FGg));
Total(7) = sum(sum(FGm));
Total(8) = sum(sum(FMg));
Total(9) = sum(sum(sum(PGg)));
Total(10) = sum(sum(PG));
Total(11) = sum(sum(sum(PMm)));
Total(12) = sum(sum(sum(PMg)));
Total(13) = sum(sum(PM));
Total(14) = sum(X);
Total(15) = sum(sum(Xg));
Total(16) = sum(sum(Xm));
Total(17) = sum(JMm);
Total(18) = sum(JGm);
Total(19) = sum(JMf);
Total(20) = sum(JGf);

Population = sum(Total);
Over = Population - CAP;
count = 0;


if Over >0
DeadPopulation = randsample(length(Total),Over,true,Total);
% Deaths = find(TotalVec);
% DeadPopulation = randi(length(Deaths),Over,1);
for k = 1:Over
    i = DeadPopulation(k);
    count = count +1;
    if i==1 %FM Death
        if sum(FM)>0
        dFM = randi(sum(FM));
        FMAge = sum((cumsum(FM)<dFM))+1;
        FM(FMAge) = FM(FMAge) - 1;
        end
    elseif i==2 %FG Death
        if sum(FG)>0
        dFG = randi(sum(FG));
        FGAge = sum(cumsum(FG)<dFG) +1;
        FG(FGAge) = FG(FGAge) - 1;
        end
    elseif i==3 %M Death
        if sum(M)>0
        dM = randi(sum(M));
        MAge = sum(cumsum(M)<dM)+1;
        M(MAge) = M(MAge) - 1;
        end
    elseif i==4 %G Death
        if sum(G)>0
        dG = randi(sum(G));
        GAge = sum(cumsum(G)<dG) +1;
        G(GAge) = G(GAge) - 1;
        end
    elseif i==5 %FMm Death
        if numel(find(FMm))>0
            FMmAge = find(FMm);
            FMm(FMmAge(end)) = FMm(FMmAge(end)) - 1;
        end
    elseif i==6 %FGg Death
        if numel(find(FGg))>0
            FGgAge = find(FGg);
            FGg(FGgAge(end)) = FGg(FGgAge(end)) - 1;
        end
    elseif i==7 %FGm Death
        if numel(find(FGm))>0
            FGmAge = find(FGm);
            FGm(FGmAge(end)) = FGm(FGmAge(end)) - 1;
        end
    elseif i==8 %FMg Death
        if numel(find(FMg))>0
            FMgAge = find(FMg);
            FMg(FMgAge(end)) = FMg(FMgAge(end)) - 1;
        end
    elseif i==9 %PGg Death
         if numel(find(PGg))>0
            ind=find(PGg);
            [PGga,PGgb,PGgc] = ind2sub(size(PGg),ind);
            PGg(PGga(end),PGgb(end),PGgc(end)) = PGg(PGga(end),PGgb(end),PGgc(end)) - 1;
        if randi(2)==1 %Female
             FGg(PGga(end),PGgc(end)) = FGg(PGga(end),PGgc(end)) + 1;    %PGg --> FGg
        else          %Male
            G(PGgb(end)) = G(PGgb(end)) + 1; %PGg -->G
        end
        end
    elseif i==10 %PG Death
        if numel(find(PG))>0
            [PGr,PGc]=find(PG);
        PG(PGr(end),PGc(end)) = PG(PGr(end),PGc(end)) - 1;

            if randi(2)==1 %Female
                FG(PGr(end)) = FG(PGr(end)) + 1;    %PG --> FG
            else          %Male
                G(PGc(end)) = G(PGc(end)) + 1; %PG -->G
            end
        end
    elseif i==11 %PMm Death
         if numel(find(PMm))>0
            ind=find(PMm);
            [PMma,PMmb,PMmc] = ind2sub(size(PMm),ind);
            PMm(PMma(end),PMmb(end),PMmc(end)) = PMm(PMma(end),PMmb(end),PMmc(end)) - 1;
            if randi(2)==1 %Female
                FMm(PMma(end),PMmc(end)) = FMm(PMma(end),PMmc(end)) + 1;    %PMm --> FMm
            else          %Male
                G(PMmb(end)) = G(PMmb(end)) + 1; %PMm -->G
            end
        end
    elseif i==12 %PMg Death
         if numel(find(PMg))>0
            ind=find(PMg);
            [PMga,PMgb,PMgc] = ind2sub(size(PMg),ind);
            PMg(PMga(end),PMgb(end),PMgc(end)) = PMg(PMga(end),PMgb(end),PMgc(end)) - 1;
            if randi(2)==1 %Female
                FMg(PMga(end),PMgc(end)) = FMg(PMga(end),PMgc(end)) + 1;    %PMg --> FMg
            else          %Male
                G(PMgb(end)) = G(PMgb(end)) + 1; %PMg -->G
            end
         end
    elseif i==13 %PM Death
        if numel(find(PM))>0
            [PMr,PMc]=find(PM);
            PM(PMr(end),PMc(end)) = PM(PMr(end),PMc(end)) - 1;
            if randi(2)==1 %Female
                FM(PMr(end)) = FM(PMr(end)) + 1;    %PM --> FM
            else          %Male
                G(PMc(end)) = G(PMc(end)) + 1; %PM --> G
            end
        end
    elseif i==14 %X Death
        if sum(X)>0
            dX = randi(sum(X));
            XAge = sum(cumsum(X)<dX) +1;
            X(XAge) = X(XAge) - 1;
        end
    elseif i==15 %Xg Death
        if numel(find(Xg))>0
            XgAge = find(Xg);
            Xg(XgAge(end)) = Xg(XgAge(end)) - 1;
        end
    elseif i==16 %Xm Death
        if numel(find(Xm))>0
            XmAge = find(Xm);
            Xm(XmAge(end)) = Xm(XmAge(end)) - 1;
        end
    elseif i==17 %JMm Death
        if sum(JMm)>0
            dJMm = randi(sum(JMm));
            JMmAge = sum(cumsum(JMm)<dJMm) +1;
            JMm(JMmAge) = JMm(JMmAge) - 1;
        end
    elseif i==18 %JGm Death
        if sum(JGm)>0
            dJGm = randi(sum(JGm));
            JGmAge = sum(cumsum(JGm)<dJGm) +1;
            JGm(JGmAge) = JGm(JGmAge) - 1;
        end
    elseif i==19 %JMf Death
        if sum(JMf)>0
            dJMf = randi(sum(JMf));
            JMfAge = sum(cumsum(JMf)<dJMf) +1;
            JMf(JMfAge) = JMf(JMfAge) - 1;
        end
   elseif i==20 %JGf Death
        if sum(JGf)>0
            dJGf = randi(sum(JGf));
            JGfAge = sum(cumsum(JGf)<dJGf) +1;
            JGf(JGfAge) = JGf(JGfAge) - 1;
        end
    end
end

FM( FM<0 ) = 0;
FG( FG<0 ) = 0;
M( M<0 ) = 0;
G( G<0 ) = 0;
FMm( FMm<0 ) = 0;
FGg( FGg<0 ) = 0;
FGm( FGm<0 ) = 0;
FMg( FMg<0 ) = 0;
PGg( PGg<0 ) = 0;
PG( PG<0 ) = 0;
PMm( PMm<0 ) = 0;
PMg( PMg<0 ) = 0;
PM( PM<0 ) = 0;
X( X<0 ) = 0;
Xg( Xg<0 ) = 0;
Xm( Xm<0 ) = 0;
JMm( JMm<0 ) = 0;
JGm( JGm<0 ) = 0;
JMf( JMf<0 ) = 0;
JGf( JGf<0 ) = 0;
else
end
end