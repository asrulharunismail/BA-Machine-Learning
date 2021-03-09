clc;
clear;
close all;

%% Problem
X=unifrnd(-10,10,500,2);
c = 3;
ObjFunction=@(centroid) MinTotDistance(X, centroid);

VarSize=[c size(X,2)]; 
Dims=prod(VarSize);    

MinBound= repmat(min(X),c,1);   
MaxBound= repmat(max(X),c,1);   

range=MaxBound(1)-MinBound(1);

%% SBA
MaxEval = 10000;
n=10;
nep =10;
Shrink = 0.5;
accuracy=0.001;
stlim=5;
recruitment = round(linspace(nep,1,n));
ColonySize=sum(recruitment);  
MaxIt=round(MaxEval/ColonySize);

%% Initialization
EmptyPatch.Position=[];
EmptyPatch.Cost=[];
EmptyPatch.Out=[];
EmptyPatch.Size=[];
EmptyPatch.Stagnated =[];
EmptyPatch.counter=[];
Patch=repmat(EmptyPatch,n,1);
counter=0;

% Initial Solutions
for i=1:n
    Patch(i).Position=unifrnd(MinBound,MaxBound,VarSize);
    [Patch(i).Cost,Patch(i).Out]=ObjFunction(Patch(i).Position);
    Patch(i).Size = range;
    Patch(i).Stagnated = 0;
    counter=counter+1;
    Patch(i).counter= counter;
end

size = linspace(0,1,n);

%% Sites Selection 
[~, RankOrder]=sort([Patch.Cost]);
Patch=Patch(RankOrder);
BestCost=zeros(MaxIt,1);

%% Bees Algorithm Local and Global Search
for it=1:MaxIt
    if counter >= MaxEval
        break;
    end

    % All Sites (Exploitation and Exploration)
    for i=1:n

        BestPatch.Cost=inf;

        assigntment=D_Tri_real_array(0,size(i),1,1,recruitment(i));

        for j=1:recruitment(i)
            Bee.Position= Integrated_Foraging_stlim(Patch(i).Position,assigntment(j),MaxBound(1),MinBound(1),Patch(i).Size);
            [Bee.Cost,Bee.Out]=ObjFunction(Bee.Position);
            Bee.Size= Patch(i).Size;
            Bee.Stagnated = Patch(i).Stagnated;
            counter=counter+1;
            Bee.counter= counter;
            if Bee.Cost<BestPatch.Cost
                BestPatch=Bee;
            end
        end

        if BestPatch.Cost<Patch(i).Cost
            Patch(i)=BestPatch;
            Patch(i).Stagnated=0;
        else
            Patch(i).Stagnated=Patch(i).Stagnated+1;
            Patch(i).Size=Patch(i).Size*Shrink;
        end

        %site abandonment procedure
        if(Patch(i).Stagnated>stlim)
            Patch(i)=Patch(end);
            Patch(i).Size=range;
            Patch(i).Stagnated=0;
        end

    end

    % Sort
    [~, RankOrder]=sort([Patch.Cost]);
    Patch=Patch(RankOrder);

    % Update Best Solution 
    OptSol=Patch(1);
    BestCost(it)=OptSol.Cost;

    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it)) '--> Evaluation = ' num2str(OptSol.counter)]);

    % Plotting
    figure(1);
    Plotting(X, OptSol);
    pause(0.01);

end

figure;
plot(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;

