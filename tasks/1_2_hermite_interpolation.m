function 1_2_hermite_interpolation(f_0, f_1, f_0_deriv, f_1_deriv)
    figure;
    hold on;
    axis equal;
    grid on;
    scatter(0,h0, 100,'r','filled')
    scatter(1,h1, 100,'r','filled')
    
    % range
    x = 0:0.0001:1;
    
    % Compute cubic hermite polinomial assuming 
    %   f(0) = f_0
    %   f(1) = f_1
    %   f(0)' = f_0_deriv
    %   f(1)' = f_1_deriv
                    
    plot(x,y,'LineWidth',2);
    hold off;
end
