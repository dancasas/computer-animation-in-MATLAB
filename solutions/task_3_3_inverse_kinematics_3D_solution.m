
function task_3_3_inverse_kinematics_3D_solution()
    cla;
    
    trans0 = [0,0,0];
    trans1 = [-1,-1,0]; % Offset wrt joint 0
    trans2 = [0,-1,0];  % Offset wrt joint 1
    trans3 = [0,-1,0];  % Offset wrt joint 2

    rot1 = [0 0 0];     % Local rotation joint 0 (eje x y z)
    rot2 = [0 0 0];     % Local rotation joint 1 (eje x y z)
    rot3 = [0 0 0];     % Local rotation joint 2 (eje x y z)

    skeleton = [trans0; trans1; trans2; trans3];
    rots = [rot1; rot2; rot3];
    
    a = 0.1;        % Velocity (alpha)
    b = 1.971197;   % To compute target
    inc = 0.01;     % To compute numeric Jacobian
    target = [b b b];
    current_position = get_final_pos(skeleton,rots);
    
    %figure;
    rotsV = rots;
    while(error(current_position, target) > 0.1)
        clf;
        
        hold on;
        grid on;
        axis equal;
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        xlim([-3 3]);
        ylim([-3 3]);
        zlim([-3 3]);
        view([3 3 3]);
       
        
        % Draws current state
        plot_skeleton(skeleton, rotsV);
        scatter3(target(1), target(2), target(3), 200,'o','filled','MarkerFaceColor',[1 .67 .0]);
        
        % Projects target to plane (for visualization purposes)
        scatter3(-3, target(2), target(3), 50,'o','filled','black');
        line([-3,target(1)],[target(2),target(2)],[target(3),target(3)],'Color','r');
        scatter3(target(1), -3, target(3), 50,'o','filled','black');
        line([target(1),target(1)],[-3,target(2)],[target(3),target(3)],'Color','g');
        scatter3(target(1), target(2), -3, 50,'o','filled','black');
        line([target(1),target(1)],[target(2),target(2)],[-3,target(3)],'Color','b');
        
        % Projects end effector
        line([-3,-3],[current_position(2),current_position(2)],[-3,3],'Color','r');
        line([-3,-3],[-3,3],[current_position(3),current_position(3)],'Color','r');
        scatter3(-3, current_position(2), current_position(3), 50,'o','filled','red');
        
        line([current_position(1),current_position(1)],[-3,-3],[-3,3],'Color','g');
        line([-3,3],[-3,-3],[current_position(3),current_position(3)],'Color','g');
        scatter3(current_position(1), -3, current_position(3), 50,'o','filled','green');
        
        line([current_position(1),current_position(1)],[-3,3],[-3,-3],'Color','b');
        line([-3,3],[current_position(2),current_position(2)],[-3,-3],'Color','b');
        scatter3(current_position(1), current_position(2), -3, 50,'o','filled','blue');
        
        drawnow;

        % Computes current Jacobian
        J = compute_jacobian(skeleton, rotsV, inc);       

        % Computes updates of joint angles
        pIJ = pinv(J);
        dO = pIJ * (target - current_position)';
        
        % Updates joint anlges
        rotsV = actualiza_rots(rotsV, a*dO'); 
        
        % Computes current position of end effecto
        current_position = get_final_pos(skeleton, rotsV);
        
        if(error(current_position, target) <= 0.1)
            target = (2*b*rand(3,1)-b)';
        end
    end
    hold off;
end

% =====
% Error
% =====

function err = error(current_position, target)
    err = norm(current_position-target);
end

% ===============
% Updates rots
% ===============

function new_Rots=actualiza_rots(old_Rots, dO)
    new_Rots = old_Rots;
    l = length(old_Rots);
    for i = 1:l
        for j = 1:3
            new_Rots(i,j) = new_Rots(i,j) + dO(3*(i-1)+j);
        end
    end
end

% =======
% Draw
% =======

function plot_skeleton(skeleton, rots)   
    % Aplicamos nodo i
    pos = 1;
    l = length(rots);
    for i = 0:l
        [pos, old_pos] = get_positions(skeleton, rots, i, pos);
        if i == 0
            scatter3(pos(1,4), pos(2,4), pos(3,4), 350,'o','filled','r');
        else
            scatter3(pos(1,4), pos(2,4), pos(3,4), 200,'o','filled','MarkerFaceColor',[.50 .8 .1]);
        end    
        if(i~=0)
            line([pos(1,4),old_pos(1,4)],[pos(2,4),old_pos(2,4)],[pos(3,4),old_pos(3,4)],'Color',[0, 0.4470, 0.7410],'LineWidth', 2);
        end
    end
end

% =========
% Jacobian
% =========

function J = compute_jacobian(skeleton, rots, inc) 
    l = length(rots);
    J = zeros(3,l);
    pos0 = get_final_pos(skeleton,rots);
    for i = 1:l
        for j = 1:3
            rotsi = rots;
            rotsi(i,j) = rotsi(i,j) + inc;
            posi = get_final_pos(skeleton,rotsi);
            J(:,3*(i-1)+j) = [posi(1)-pos0(1) posi(2)-pos0(2) posi(3)-pos0(3)];
        end
    end
    J = J/inc;
end

% =========================
% Computes end effector position 
% =========================

function pos = get_final_pos(skeleton,rots)
    l = length(rots);
    aux = 1;
    for i = 1:l
        [aux, ~] = get_positions(skeleton, rots, i, aux);
    end
    pos = [aux(1,4) aux(2,4) aux(3,4)];
end

function [pos, old_pos] = get_positions(skeleton, rots, i, pos)
    if(i==0)
        rotiX = 0;
        rotiY = 0;
        rotiZ = 0;
    else
        rotiX = rots(i,1);
        rotiY = rots(i,2);
        rotiZ = rots(i,3);

    end

    rotX_matrix = [ 1 0            0              0;
                    0 +cosd(rotiX) -sind(rotiX)   0;
                    0 +sind(rotiX) +cosd(rotiX)   0;
                    0 0            0              1];
    rotY_matrix = [ +cosd(rotiY) 0 +sind(rotiY)   0;
                    0            1 0              0;
                    -sind(rotiY) 0 +cosd(rotiY)   0;
                    0            0 0              1];
    rotZ_matrix = [ +cosd(rotiZ) -sind(rotiZ) 0   0;
                    +sind(rotiZ) +cosd(rotiZ) 0   0;
                    0           0             1   0;
                    0           0             0   1];
    roti_matrix = rotX_matrix * rotY_matrix * rotZ_matrix;

    transi_matrix = [1 0 0 skeleton(i+1,1);
                     0 1 0 skeleton(i+1,2);
                     0 0 1 skeleton(i+1,3);
                     0 0 0 1];
    old_pos = pos;
    pos     = old_pos * roti_matrix * transi_matrix ;
end

