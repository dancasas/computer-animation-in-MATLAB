function skeleton_demo()
    
    close all;

    % defines joint positions in rest pose
    trans0 = [0,0];
    trans1 = [0,1]; % Offset with respect joint 0 in rest pose
    trans2 = [0,1]; % Offset with respect joint 1 in rest pose
    trans3 = [0,1]; % Offset with respect joint 2 in rest pose
    
    rot1 = 0;      % Local rotation for first joint
    rot2 = 0;      % Local rotation for second joint
    rot3 = 0;       % Local rotation for third joint
    
    % puts skeleton defintion in vector
    skeleton = [trans0; trans1; trans2; trans3];
    rots = [rot1 rot2 rot3];
    
    figure;
    hold on;
    grid on;
    axis equal;
    xlim([-4 4]);
    ylim([-4 4]);
    
    plot_skeleton(skeleton, rots);
    
    hold off;
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
    
    %
    % !! TO COMPLETE !!
    % !! compute the location of two more joints of the chain
    %
    
    % plot joints 
    scatter(joint_one_pos(1,3), joint_one_pos(2,3),450,'o','filled','r');
    scatter(joint_two_pos(1,3), joint_two_pos(2,3),250,'o','filled','MarkerFaceColor',[.50 .8 .1]);
    
end
