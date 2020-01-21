function task_1_5_quadratic_spline_solution()
    hold on;
    grid on;
    % Sample points. Let's interpolate them with quadratic slpines
    x_input = [-3, -1, 1, 3];
    y_input = [15,  5, 8, 9];
    scatter(x_input,y_input,80,'filled','MarkerFaceColor',[1 0 0]);
    
    %% 8x9 solution
        
    % Defines matrix A (8 equations, 9 unknowns)
     A8x9 = [9   -3   1   0    0   0   0   0   0;
             1   -1   1   0    0   0   0   0   0;
             0    0   0   1   -1   1   0   0   0;
             0    0   0   1    1   1   0   0   0;
             0    0   0   0    0   0   1   1   1;
             0    0   0   0    0   0   9   3   1;
            -2    1   0   2   -1   0   0   0   0;
             0    0   0   2    1   0  -2  -1   0];
    
            b = [15 5 5 8 8 9 0 0]';
    
    % MATLAB choses what to do with 9 unknowns
    X8x9 = linsolve(A8x9,b);
    
    % Plots 1st segment 
    x = x_input(1):0.01:x_input(2);
    y = X8x9(1)*x.^2 + X8x9(2)*x + X8x9(3);
    plot(x, y,'LineWidth', 2);
    
    % Plots 2nd segment 
    x = x_input(2):0.01:x_input(3);
    y = X8x9(4)*x.^2 + X8x9(5)*x + X8x9(6);
    plot(x,y,'LineWidth', 2);
    
    % Plots 3rd segment
    x = x_input(3):0.01:x_input(4);
    y = X8x9(7)*x.^2 + X8x9(8)*x + X8x9(9);
    plot(x,y,'LineWidth', 2);
    
    hold off;
    
    %% 8x8 Solution
    
    figure;
    hold on;
    grid on;
    scatter(x_input,y_input,80,'filled','MarkerFaceColor',[1 0 0]);
    
    % if we force, a1 = 0, A matrix is now 8x8 (1st column disappear)
    A8x8 = [-3   1   0    0   0   0   0   0;
            -1   1   0    0   0   0   0   0;
             0   0   1   -1   1   0   0   0;
             0   0   1    1   1   0   0   0;
             0   0   0    0   0   1   1   1;
             0   0   0    0   0   9   3   1;
             1   0   2   -1   0   0   0   0;
             0   0   2    1   0  -2  -1   0];

     X8x8 = linsolve(A8x8,b);
    
    % Plots 1st segment (we enforced a_1 = 0, so this is a linear segment)
    x = x_input(1):0.01:x_input(2);
    y = X8x8(1)*x + X8x8(2);
    plot(x, y,'LineWidth', 2);
    
    % Plots 2nd segment 
    x = x_input(2):0.01:x_input(3);
    y = X8x8(3)*x.^2 + X8x8(4)*x + X8x8(5);
    plot(x,y,'LineWidth', 2);
    
    % Plots 3rd segment
    x = x_input(3):0.01:x_input(4);
    y = X8x8(6)*x.^2 + X8x8(7)*x + X8x8(8);
    plot(x,y,'LineWidth', 2);
    
    hold off;
end
