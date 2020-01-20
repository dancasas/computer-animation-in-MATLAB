function compute_global_blendshapes()
    close all
     
    blendshape_path = '../data/blendshapes/'
     
    % Reads and vectorizes mesh
    [V00,F] = read_vertices_and_faces_from_obj_file(strcat(blendshape_path,'/neutral-tri.obj'));
    V00 = vertcat(V00(:,1),V00(:,2),V00(:,3));
    
    num_vertices = size(V00,1);
    
    % Reads and vectorizes mesh 02
    [V02,F] = read_vertices_and_faces_from_obj_file(strcat(blendshape_path, '/left-smile-tri.obj'));
    V02 = vertcat(V02(:,1),V02(:,2),V02(:,3));
     
    % Reads and vectorizes mesh 03
    [V03,F] = read_vertices_and_faces_from_obj_file(strcat(blendshape_path, '/right-smile-tri.obj'));
    V03 = vertcat(V03(:,1),V03(:,2),V03(:,3));
         
    % Reads and vectorizes mesh 04
    [V04,F] = read_vertices_and_faces_from_obj_file(strcat(blendshape_path, '/mouth-o-tri.obj'));
    V04 = vertcat(V04(:,1),V04(:,2),V04(:,3));
     
    % Reads and vectorizes mesh 05
    [V05,F] = read_vertices_and_faces_from_obj_file(strcat(blendshape_path, '/left-brow-up-tri.obj'));
    V05 = vertcat(V05(:,1),V05(:,2),V05(:,3));
     
    % Reads and vectorizes mesh 06
    [V06,F] = read_vertices_and_faces_from_obj_file(strcat(blendshape_path, '/left-brow-outter-up-tri.obj'));
    V06 = vertcat(V06(:,1),V06(:,2),V06(:,3));
     
    % Reads and vectorizes mesh 07
    [V07,F] = read_vertices_and_faces_from_obj_file(strcat(blendshape_path, '/mouth-AA-tri.obj'));
    V07 = vertcat(V07(:,1),V07(:,2),V07(:,3));
     
    % Reads and vectorizes mesh 08
    [V08,F] = read_vertices_and_faces_from_obj_file(strcat(blendshape_path, '/sad-tri.obj'));
    V08 = vertcat(V08(:,1),V08(:,2),V08(:,3));
     
    % Reads and vectorizes mesh 09
    [V09,F] = read_vertices_and_faces_from_obj_file(strcat(blendshape_path, '/right-eye-down-tri.obj'));
    V09 = vertcat(V09(:,1),V09(:,2),V09(:,3));
     
    % Reads and vectorizes mesh 10
    [V10,F] = read_vertices_and_faces_from_obj_file(strcat(blendshape_path,'/left-eye-down-tri.obj'));
    V10 = vertcat(V10(:,1),V10(:,2),V10(:,3));
     
    figure;
 
    t=0:0.2:1;
    t = [t flip(t)];
    iterations = 0;
     
     
    % Animation loop
    while 1
       iterations = mod(iterations,size(t,2)) + 1;
        
       % current weight
       alpha = t(iterations);
        
       % Stores current viewpoint
       [az, el] = view;
        
       % Updates current shape
       %V_blend = V00(:) * (1-alpha) + V07(:) * (alpha);
       V_blend = V00(:) * (1-alpha) + V07(:) * (alpha) *2;
        
       % Reshapes from vectorized mesh to [num_vertices,3]
       V_blend = reshape(V_blend,[num_vertices,3]);
        
        % Draws mesh
        trisurf(F,V_blend(:, 1),...
                  V_blend(:, 2),...
                  V_blend(:, 3),...
                  'FaceColor',[0.26,0.63,1.0 ],'EdgeColor','none','LineStyle','none','SpecularStrength',0.4);
       
        % Sets current viewpoint
        view (az, el);
        
        % Set up lighing
        light('Position',[-1.0,-1.0,100.0],'Style','infinite');
        lighting phong;
         
        % Set up axis
        axis equal
        axis([-1.5 1.5 0 2 -1 1.5])
        
        drawnow;
    end
end
