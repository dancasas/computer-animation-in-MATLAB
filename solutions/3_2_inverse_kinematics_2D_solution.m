function skeleton_demo()
    
    close all;

    % defines joint positions in rest pose
    trans0 = [0,0];
    trans1 = [0,1]; % Offset with respect joint 0 in rest pose
    trans2 = [0,1]; % Offset with respect joint 1 in rest pose
    trans3 = [0,1]; % Offset with respect joint 2 in rest pose
    
    rot1 = 160;       % Rotacion local del joint 0
    rot2 = -40;       % Rotacion local del joint 1
    rot3 = 95;       % Rotacion local del joint 2
    
    % puts skeleton defintion in vector
    skeleton = [trans0; trans1; trans2; trans3];
    rots = [rot1 rot2 rot3];
    
    figure;
    hold on;
    grid on;
    axis equal;
    xlim([-4 4]);
    ylim([-4 4]);
    
    %plot_skeleton(skeleton, rots);
    
    hold off;
    
    run_IK(skeleton)
    
end


function plot_skeleton(skeleton, rots)
                      
    rot1 = rots(1);
    rot2 = rots(2);
    rot3 = rots(3);
    
    % Computes first joint position     
    rot0_matrix = [ 1 0 0;  
                    0 1 0; 
                    0 0 1]; 
                
    trans0_matrix = [1 0 skeleton(1,1);
                     0 1 skeleton(1,2);
                     0 0 1]; 
                 
    joint_one_pos = rot0_matrix * trans0_matrix;
    
    % Computes second joint position 
    rot1_matrix = [ +cosd(rot1) -sind(rot1) 0;  
                    +sind(rot1) +cosd(rot1) 0; 
                    0          0          1 ];      
        
    trans1_matrix = [1 0 skeleton(2,1);
                     0 1 skeleton(2,2);
                     0 0 1]; 
         
    joint_two_pos     =   rot0_matrix * trans0_matrix ...
                        * rot1_matrix * trans1_matrix ;
    
    line([joint_two_pos(1,3),joint_one_pos(1,3)],...
         [joint_two_pos(2,3),joint_one_pos(2,3)], 'LineWidth', 5);
    
    % Computes third joint position 
    rot2_matrix = [ +cosd(rot2) -sind(rot2) 0;  
                    +sind(rot2) +cosd(rot2) 0; 
                    0          0          1 ];      
        
    trans2_matrix = [1 0 skeleton(3,1);
                     0 1 skeleton(3,2);
                     0 0 1]; 
                
    joint_three_pos     =   rot0_matrix * trans0_matrix * ...
                            rot1_matrix * trans1_matrix * ... 
                            rot2_matrix * trans2_matrix ;
    
    line([joint_three_pos(1,3),joint_two_pos(1,3)],[joint_three_pos(2,3),joint_two_pos(2,3)], 'LineWidth', 5);
    
    % Computes fourth joint position 
    rot3_matrix = [ +cosd(rot3) -sind(rot3) 0;  
                    +sind(rot3) +cosd(rot3) 0; 
                     0           0          1 ];      
        
    trans3_matrix = [1 0 skeleton(4,1);
                     0 1 skeleton(4,2);
                     0 0 1]; 
                
    joint_four_pos = rot0_matrix * trans0_matrix * ...
                     rot1_matrix * trans1_matrix * ... 
                     rot2_matrix * trans2_matrix * ...
                     rot3_matrix * trans3_matrix;
   
    line([joint_four_pos(1,3),joint_three_pos(1,3)],[joint_four_pos(2,3),joint_three_pos(2,3)], 'LineWidth', 5);
    
    % plot joints 
    scatter(joint_one_pos(1,3), joint_one_pos(2,3),450,'o','filled','r');
    scatter(joint_two_pos(1,3), joint_two_pos(2,3),250,'o','filled','MarkerFaceColor',[.50 .8 .1]);
    scatter(joint_three_pos(1,3), joint_three_pos(2,3),250,'o','filled','MarkerFaceColor',[.50 .8 .1]);
end

function run_IK(skeleton)
    
    figure;
    
    % initial rotations
    rots = [0.1 0.1 0.1];
    errors = [];
   
    % random target
    target = [(rand(1)*5 - 2.5),rand(1)*5 - 2.5];
    
    iterations = 0;
    while 1
        iterations = iterations + 1;
        current_error = compute_error(target, skeleton, rots(1), rots(2), rots(3));
        
        clf;
        hold on;
        grid on;
        axis equal;
        xlim([-4 4])
        ylim([-4 4])
        plot_skeleton(skeleton, rots)
        
        % plots target point (size OK to export PDF)
        % scatter(target(1), target(2), 40, 'x','LineWidth',25,'MarkerEdgeColor',[1 .67 .0],'MarkerFaceColor',[0 .7 .7]);
        % plots target point (size OK for interactive view)
        scatter(target(1), target(2), 250, 'x','LineWidth',25,'MarkerEdgeColor',[1 .67 .0],'MarkerFaceColor',[0 .7 .7]);
         
        
        % To display current error
          h = annotation('textbox',...
            [0.40 0.9 0.8 0.0],...
            'FontSize',20,...
            'FontName','Courier',...
            'FontWeight','bold',...
            'EdgeColor',[1 1 0.9],...
            'Color',[0.84 0.16 0]);
            set(h,'String',['Error     = ' num2str(current_error)]); % fast and easy
            
           h2 = annotation('textbox',...
            [0.40 0.85 0.8 0.0],...
            'FontSize',20,...
            'FontName','Courier',...
            'FontWeight','bold',...
            'EdgeColor',[1 1 0.9],...
            'Color',[0.84 0.16 0]);
            set(h2,'String',['Iteration = ' num2str(iterations)]); % fast and easy
        drawnow;
        hold off;
        
        errors = [errors current_error];
      
        if((current_error < 0.2) || (iterations > 50))
            target = [(rand(1)*6 - 3),rand(1)*6 - 3];
            iterations = 0;
            errors = [];
            %break;
        end
        
        J = compute_jacobian(skeleton, rots(1), rots(2), rots(3), 1, 1, 1);
        
        current_position = compute_position(skeleton, rots(1), rots(2), rots(3));
        
        update = pinv(J) * (target - [current_position(1,3) current_position(2,3)])';

        % scaling factor 
        alpha = 0.1;
        
        % updates rots
        rots(1) = rots(1) + alpha * update(1);
        rots(2) = rots(2) + alpha * update(2);
        rots(3) = rots(3) + alpha * update(3);
    end
    %figure;
    %plot (errors);
end

function pos = compute_position(skeleton, rot1, rot2, rot3)
    
    rot0_matrix = [ 1 0 0;  
                    0 1 0; 
                    0 0 1]; 
                
    trans0_matrix = [1 0 skeleton(1,1);
                     0 1 skeleton(1,2);
                     0 0 1]; 
                 
    rot1_matrix = [ +cosd(rot1) -sind(rot1) 0;  
                    +sind(rot1) +cosd(rot1) 0; 
                    0          0          1 ];      
        
    trans1_matrix = [1 0 skeleton(2,1);
                     0 1 skeleton(2,2);
                     0 0 1]; 
 
  
    rot2_matrix = [ +cosd(rot2) -sind(rot2) 0;  
                    +sind(rot2) +cosd(rot2) 0; 
                    0          0          1 ];      
        
    trans2_matrix = [1 0 skeleton(3,1);
                     0 1 skeleton(3,2);
                     0 0 1]; 
                

    rot3_matrix = [ +cosd(rot3) -sind(rot3) 0;  
                    +sind(rot3) +cosd(rot3) 0; 
                    0          0          1 ];      
        
    trans3_matrix = [1 0 skeleton(4,1);
                    0 1 skeleton(4,2);
                    0 0 1]; 
                
    pos     =   rot0_matrix * trans0_matrix * ...
                rot1_matrix * trans1_matrix * ... 
                rot2_matrix * trans2_matrix * ...
                rot3_matrix * trans3_matrix;
end


function error = compute_error(target, skeleton, rot1, rot2, rot3)

    rot0_matrix = [ 1 0 0;  
                    0 1 0; 
                    0 0 1]; 
                
    trans0_matrix = [1 0 skeleton(1,1);
                     0 1 skeleton(1,2);
                     0 0 1]; 
                 
    rot1_matrix = [ +cosd(rot1) -sind(rot1) 0;  
                    +sind(rot1) +cosd(rot1) 0; 
                    0          0          1 ];      
        
    trans1_matrix = [1 0 skeleton(2,1);
                     0 1 skeleton(2,2);
                     0 0 1]; 

    rot2_matrix = [ +cosd(rot2) -sind(rot2) 0;  
                    +sind(rot2) +cosd(rot2) 0; 
                    0          0          1 ];      
        
    trans2_matrix = [1 0 skeleton(3,1);
                     0 1 skeleton(3,2);
                     0 0 1];    
                 
    rot3_matrix = [ +cosd(rot3) -sind(rot3) 0;  
                    +sind(rot3) +cosd(rot3) 0; 
                    0          0          1 ];      
        
    trans3_matrix = [1 0 skeleton(4,1);
                    0 1 skeleton(4,2);
                    0 0 1]; 
                                
    pos     =   rot0_matrix * trans0_matrix * ...
                rot1_matrix * trans1_matrix * ... 
                rot2_matrix * trans2_matrix * ...
                rot3_matrix * trans3_matrix;
            
    error = sqrt((target(1) - pos(1,3))^2 + (target(2) - pos(2,3))^2);
    
    %fprintf('target: [%f, %f]     pos: [%f, %f]\n', target(1), target(2), pos(1,3), pos(2,3));
    %fprintf('ERROR = %f\n', error);
end

function J = compute_jacobian(skeleton, rot1, rot2, rot3, inc_rot1, inc_rot2, inc_rot3)
    % For rot1
    % Current
    rot0_matrix = [ 1 0 0;  
                    0 1 0; 
                    0 0 1]; 
                
    trans0_matrix = [1 0 skeleton(1,1);
                     0 1 skeleton(1,2);
                     0 0 1]; 
                 
    rot1_matrix = [ +cosd(rot1) -sind(rot1) 0;  
                    +sind(rot1) +cosd(rot1) 0; 
                    0          0          1 ];      
        
    trans1_matrix = [1 0 skeleton(2,1);
                     0 1 skeleton(2,2);
                     0 0 1]; 

    rot2_matrix = [ +cosd(rot2) -sind(rot2) 0;  
                    +sind(rot2) +cosd(rot2) 0; 
                    0          0          1 ];      
        
    trans2_matrix = [1 0 skeleton(3,1);
                     0 1 skeleton(3,2);
                     0 0 1];    
                 
    rot3_matrix = [ +cosd(rot3) -sind(rot3) 0;  
                    +sind(rot3) +cosd(rot3) 0; 
                    0          0          1 ];      
        
    trans3_matrix = [1 0 skeleton(4,1);
                    0 1 skeleton(4,2);
                    0 0 1]; 
                                
    current_pos     =   rot0_matrix * trans0_matrix * ...
                rot1_matrix * trans1_matrix * ... 
                rot2_matrix * trans2_matrix * ...
                rot3_matrix * trans3_matrix;
    
    % rot1 + inc_rot1    
    rot0_matrix = [ 1 0 0;  
                    0 1 0; 
                    0 0 1]; 
                
    trans0_matrix = [1 0 skeleton(1,1);
                     0 1 skeleton(1,2);
                     0 0 1]; 
                 
    rot1_matrix = [ +cosd(rot1+ inc_rot1) -sind(rot1 + inc_rot1) 0;  
                    +sind(rot1+ inc_rot1) +cosd(rot1 + inc_rot1) 0; 
                    0          0          1 ];      
        
    trans1_matrix = [1 0 skeleton(2,1);
                     0 1 skeleton(2,2);
                     0 0 1]; 

    rot2_matrix = [ +cosd(rot2) -sind(rot2) 0;  
                    +sind(rot2) +cosd(rot2) 0; 
                    0          0          1 ];      
        
    trans2_matrix = [1 0 skeleton(3,1);
                     0 1 skeleton(3,2);
                     0 0 1];    
                 
    rot3_matrix = [ +cosd(rot3) -sind(rot3) 0;  
                    +sind(rot3) +cosd(rot3) 0; 
                    0          0          1 ];      
        
    trans3_matrix = [1 0 skeleton(4,1);
                    0 1 skeleton(4,2);
                    0 0 1]; 
                                
    inc1_pos     =  rot0_matrix * trans0_matrix * ...
                    rot1_matrix * trans1_matrix * ... 
                    rot2_matrix * trans2_matrix * ...
                    rot3_matrix * trans3_matrix;
                
    inc1x = inc1_pos(1,3) - current_pos(1,3);
    inc1y = inc1_pos(2,3) - current_pos(2,3);
    
    %fprintf('inc1x: %f     inc1y: %f\n', inc1x, inc1y);
    %% For rot2
    % Current
    rot0_matrix = [ 1 0 0;  
                    0 1 0; 
                    0 0 1]; 
                
    trans0_matrix = [1 0 skeleton(1,1);
                     0 1 skeleton(1,2);
                     0 0 1]; 
                 
    rot1_matrix = [ +cosd(rot1) -sind(rot1) 0;  
                    +sind(rot1) +cosd(rot1) 0; 
                    0          0          1 ];      
        
    trans1_matrix = [1 0 skeleton(2,1);
                     0 1 skeleton(2,2);
                     0 0 1]; 

    rot2_matrix = [ +cosd(rot2) -sind(rot2) 0;  
                    +sind(rot2) +cosd(rot2) 0; 
                    0          0          1 ];      
        
    trans2_matrix = [1 0 skeleton(3,1);
                     0 1 skeleton(3,2);
                     0 0 1];    
                 
    rot3_matrix = [ +cosd(rot3) -sind(rot3) 0;  
                    +sind(rot3) +cosd(rot3) 0; 
                    0          0          1 ];      
        
    trans3_matrix = [1 0 skeleton(4,1);
                    0 1 skeleton(4,2);
                    0 0 1]; 
                                
    current_pos     =   rot0_matrix * trans0_matrix * ...
                rot1_matrix * trans1_matrix * ... 
                rot2_matrix * trans2_matrix * ...
                rot3_matrix * trans3_matrix;
            
    % rot2 + inc_rot2    
    rot0_matrix = [ 1 0 0;  
                    0 1 0; 
                    0 0 1]; 
                
    trans0_matrix = [1 0 skeleton(1,1);
                     0 1 skeleton(1,2);
                     0 0 1]; 
                 
    rot1_matrix = [ +cosd(rot1) -sind(rot1) 0;  
                    +sind(rot1) +cosd(rot1) 0; 
                    0          0          1 ];      
        
    trans1_matrix = [1 0 skeleton(2,1);
                     0 1 skeleton(2,2);
                     0 0 1]; 

    rot2_matrix = [ +cosd(rot2+ inc_rot2) -sind(rot2 + inc_rot2) 0;  
                    +sind(rot2+ inc_rot2) +cosd(rot2 + inc_rot2) 0; 
                    0          0          1 ];      
        
    trans2_matrix = [1 0 skeleton(3,1);
                     0 1 skeleton(3,2);
                     0 0 1];    
                 
    rot3_matrix = [ +cosd(rot3) -sind(rot3) 0;  
                    +sind(rot3) +cosd(rot3) 0; 
                    0          0          1 ];      
        
    trans3_matrix = [1 0 skeleton(4,1);
                    0 1 skeleton(4,2);
                    0 0 1]; 
                                
    inc2_pos     =  rot0_matrix * trans0_matrix * ...
                    rot1_matrix * trans1_matrix * ... 
                    rot2_matrix * trans2_matrix * ...
                    rot3_matrix * trans3_matrix;
    
    inc2x = inc2_pos(1,3) - current_pos(1,3);
    inc2y = inc2_pos(2,3) - current_pos(2,3);
                
    %fprintf('inc2x: %f     inc2y: %f\n', inc2x, inc2y);
    
    %% For rot3
    % Current
    rot0_matrix = [ 1 0 0;  
                    0 1 0; 
                    0 0 1]; 
                
    trans0_matrix = [1 0 skeleton(1,1);
                     0 1 skeleton(1,2);
                     0 0 1]; 
                 
    rot1_matrix = [ +cosd(rot1) -sind(rot1) 0;  
                    +sind(rot1) +cosd(rot1) 0; 
                    0          0          1 ];      
        
    trans1_matrix = [1 0 skeleton(2,1);
                     0 1 skeleton(2,2);
                     0 0 1]; 

    rot2_matrix = [ +cosd(rot2) -sind(rot2) 0;  
                    +sind(rot2) +cosd(rot2) 0; 
                    0          0          1 ];      
        
    trans2_matrix = [1 0 skeleton(3,1);
                     0 1 skeleton(3,2);
                     0 0 1];    
                 
    rot3_matrix = [ +cosd(rot3) -sind(rot3) 0;  
                    +sind(rot3) +cosd(rot3) 0; 
                    0          0          1 ];      
        
    trans3_matrix = [1 0 skeleton(4,1);
                    0 1 skeleton(4,2);
                    0 0 1]; 
                                
    current_pos     =   rot0_matrix * trans0_matrix * ...
                rot1_matrix * trans1_matrix * ... 
                rot2_matrix * trans2_matrix * ...
                rot3_matrix * trans3_matrix;
    
            % rot3 + inc_rot3    
    rot0_matrix = [ 1 0 0;  
                    0 1 0; 
                    0 0 1]; 
                
    trans0_matrix = [1 0 skeleton(1,1);
                     0 1 skeleton(1,2);
                     0 0 1]; 
                 
    rot1_matrix = [ +cosd(rot1) -sind(rot1) 0;  
                    +sind(rot1) +cosd(rot1) 0; 
                    0          0          1 ];      
        
    trans1_matrix = [1 0 skeleton(2,1);
                     0 1 skeleton(2,2);
                     0 0 1]; 

    rot2_matrix = [ +cosd(rot2) -sind(rot2) 0;  
                    +sind(rot2) +cosd(rot2) 0; 
                    0          0          1 ];      
        
    trans2_matrix = [1 0 skeleton(3,1);
                     0 1 skeleton(3,2);
                     0 0 1];    
                 
    rot3_matrix = [ +cosd(rot3+ inc_rot3) -sind(rot3 + inc_rot3) 0;  
                    +sind(rot3+ inc_rot3) +cosd(rot3 + inc_rot3) 0; 
                    0          0          1 ];      
        
    trans3_matrix = [1 0 skeleton(4,1);
                    0 1 skeleton(4,2);
                    0 0 1]; 
                                
    inc3_pos     =  rot0_matrix * trans0_matrix * ...
                    rot1_matrix * trans1_matrix * ... 
                    rot2_matrix * trans2_matrix * ...
                    rot3_matrix * trans3_matrix;
    
    inc3x = inc3_pos(1,3) - current_pos(1,3);
    inc3y = inc3_pos(2,3) - current_pos(2,3);
                
    %fprintf('inc3x: %f     inc3y: %f\n', inc3x, inc3y);   
    
    J = [ inc1x/inc_rot1 inc2x/inc_rot2 inc3x/inc_rot3; ...
          inc1y/inc_rot1 inc2y/inc_rot2 inc3y/inc_rot3];
end
