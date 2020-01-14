function 1_3_lagrange_interpolation_solution()
    % Sample points
    hold on;
    grid on;
    % Shows axis
    ax = gca;
    ax.XAxisLocation = 'origin';
    ax.YAxisLocation = 'origin';
     
    % Sample points
    xx = [-8,  -1,  2,  7];
    yy = [-5,  5, -8, 9];
    scatter(xx, yy, 100,'filled', 'MarkerFaceColor',[1 0 0]);
     
    d1 = ((xx(1) - xx(2)) * (xx(1) - xx(3)) * (xx(1)-xx(4)));
    d2 = ((xx(2) - xx(1)) * (xx(2) - xx(3)) * (xx(2)-xx(4)));
    d3 = ((xx(3) - xx(1)) * (xx(3) - xx(2)) * (xx(3)-xx(4)));
    d4 = ((xx(4) - xx(1)) * (xx(4) - xx(2)) * (xx(4)-xx(3)));
     
    % Lagrange basis polynomials
    x=-8:0.01:7;
    l0 = ((x-xx(2)).*(x-xx(3)).*(x-xx(4)))/d1;
    l1 = ((x-xx(1)).*(x-xx(3)).*(x-xx(4)))/d2;
    l2 = ((x-xx(1)).*(x-xx(2)).*(x-xx(4)))/d3;
    l3 = ((x-xx(1)).*(x-xx(2)).*(x-xx(3)))/d4;
     
    fprintf('1/% .03f * ((x - % .03f) * (x -  % .03f) * (x -  % .03f))\n', d1, xx(2), xx(3), xx(4))
    fprintf('1/% .03f * ((x - % .03f) * (x -  % .03f) * (x -  % .03f))\n', d2, xx(1), xx(3), xx(4))
    fprintf('1/% .03f * ((x - % .03f) * (x -  % .03f) * (x -  % .03f))\n', d3, xx(1), xx(2), xx(4))
    fprintf('1/% .03f * ((x - % .03f) * (x -  % .03f) * (x -  % .03f))\n', d4, xx(1), xx(2), xx(3))
     
    plot(x, yy(1) * l0, 'LineWidth',2);
    plot(x, yy(2) * l1, 'LineWidth',2);
    plot(x, yy(3) * l2, 'LineWidth',2);
    plot(x, yy(4) * l3, 'LineWidth',2);
     
    P = yy(1) * l0 + ...
        yy(2) * l1 + ...
        yy(3) * l2 + ...
        yy(4) * l3;
     
    plot(x, P,'--k','LineWidth',2);
    hold off;
end
