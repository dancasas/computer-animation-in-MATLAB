function 1_2_hermite_interpolation_solution(h0, h1, h2, h3)
    x = 0:0.0001:1;
    figure;
    hold on;
    axis equal;
    grid on;
    scatter(0,h0, 100,'r','filled')
    scatter(1,h1, 100,'r','filled')
    
    % Hermite matrix H
    H = [2 -3 0 1; -2 3 0 0; 1 -2 1 0; 1 -1 0 0]';
    
    % h
    h = [h0; h1; h2; h3];
    
    sol = H*h;
    y = sol(1) * x.^3 + sol(2) * x.^2 + sol(3) * x + sol(4)*1 ;
    x = 0:0.0001:1;
    
    plot(x,y,'LineWidth',3);
    hold off;
end
