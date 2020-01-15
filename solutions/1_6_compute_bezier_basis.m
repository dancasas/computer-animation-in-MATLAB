function 1_6_compute_bezier_basis()
    figure;
    hold on;
    grid on;
    axis equal;
    
    % B1(t)
    x = 0:0.01:1;
    y = (1-x).^3;
    plot(x,y,'LineWidth',2);
    
    % B2(t)
    x = 0:0.01:1;
    y = 3*x.*((1-x).^2);
    plot(x,y,'LineWidth',2);
   
    
    % B3(t)
    x = 0:0.01:1;
    y = 3*x.^2.*(1-x);
    plot(x,y,'LineWidth',2);
    
    % B4(t)
    x = 0:0.01:1;
    y = x.^3;
    plot(x,y,'LineWidth',2);
    hold off;
end
