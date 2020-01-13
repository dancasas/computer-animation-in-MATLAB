function plot_hermite_basis()
    figure;
    hold on;
    grid on;
                
    % Rango
    x = 0:0.0001:1;
                
    H0 = 2*x.^3 - 3*x.^2 +1 ;
    plot(x,H0);

    % Completar...
    
    hold off;
end 
