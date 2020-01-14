  
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
    
    % Compute Lagrange basis polynomials
    
    % Plot basis
    
    % Compute L(x)
    
    % Plot Lagrange interpolator L(x)
end
