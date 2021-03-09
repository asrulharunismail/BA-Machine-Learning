function [Z, Output] = MinTotDistance(X, centroid)

    % Distance X - centroid Matrix
    Dis = pdist2(X, centroid);
    
    % Find Minimum Distances
    [MinDis, Idx] = min(Dis, [], 2);
    
    TotDis = sum(MinDis);
    
    Z=TotDis;

    Output.Dis=Dis;
    Output.MinDis=MinDis;
    Output.Idx=Idx;
    Output.TotDis=TotDis;
    
end