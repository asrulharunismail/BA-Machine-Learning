function Plotting(X, sol)

    centroid = sol.Position;
    c = size(centroid,1);
    
    Idx = sol.Out.Idx;
    
    Colors = hsv(c);
    
    for j=1:c
        Xj = X(Idx==j,:);
        plot(Xj(:,1),Xj(:,2),'x','LineWidth',1,'Color',Colors(j,:));
        hold on;
    end
    
    plot(centroid(:,1),centroid(:,2),'ok','LineWidth',2,'MarkerSize',12);
    
    hold off;
    grid on;
    
end