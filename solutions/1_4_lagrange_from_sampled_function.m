function 1_4_lagrange_from_sampled_function()
    
    % Sample points
    hold on;
    grid on;
    
    % Sample points for function f(x)=1/x
    xx = [1,   2,   3];
    yy = [1/1, 1/2, 1/3];
    scatter(xx,yy,'filled','MarkerFaceColor',[1 0 0]);
    
    d1 = ((xx(1) - xx(2)) * (xx(1) - xx(3)));
    d2 = ((xx(2) - xx(1)) * (xx(2) - xx(3)));
    d3 = ((xx(3) - xx(1)) * (xx(3) - xx(2)));
    
    % Lagrange basis polynomials
    x=min(xx):0.01:max(xx);
    l0 = ((x-xx(2)).*(x-xx(3)))/d1;
    l1 = ((x-xx(1)).*(x-xx(3)))/d2;
    l2 = ((x-xx(1)).*(x-xx(2)))/d3;
    
    % Lagrange polynomial (by hand)
    x=min(xx):0.01:max(xx);
    %l0 = 1/2 * (x-2) .* (x-3);
    %l1 = -(x-1) .* (x-3);
    %l2 = 1/2 * (x-1) .* (x-2);
    
    plot(x, yy(1) * l0, 'LineWidth', 2);
    plot(x, yy(2) * l1, 'LineWidth', 2);
    plot(x, yy(3) * l2, 'LineWidth', 2);
    
    % Interpolating polynomial
    lagrange_poly = yy(1) * l0 + yy(2) * l1 + yy(3) * l2;
    plot(x, lagrange_poly, '--k','LineWidth', 2);
    
    % Interpolated function
    %x = 0.5:0.01:4;
    y = 1./x;
    plot(x,y,'--','LineWidth',2);
    
    hold off;
    
    figure;
    hold on;
    x=1:0.01:3;
    plot(x, l0, 'LineWidth', 2);
    plot(x, l1, 'LineWidth', 2);
    plot(x, l2, 'LineWidth', 2);
    hold off;
end
