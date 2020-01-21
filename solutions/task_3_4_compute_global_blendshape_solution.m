function task_3_4_compute_global_blendshape_solution()
    close all
     
    blendshape_path = '../data/blendshapes/'
     
    % Reads and vectorizes mesh
    [V00,F] = read_vertices_and_faces_from_obj_file(strcat(blendshape_path,'/neutral-tri.obj'));
    num_vertices = size(V00,1);
    V00 = vertcat(V00(:,1),V00(:,2),V00(:,3));
    
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


function [V,F] = read_vertices_and_faces_from_obj_file(filename)
  % From: http://www.alecjacobson.com/weblog/?p=917
  % Reads a .obj mesh file and outputs the vertex and face list
  % assumes a 3D triangle mesh and ignores everything but:
  % v x y z and f i j k lines
  % Input:
  %  filename  string of obj file's path
  %
  % Output:
  %  V  number of vertices x 3 array of vertex positions
  %  F  number of faces x 3 array of face indices
  %
  V = zeros(0,3);
  F = zeros(0,3);
  vertex_index = 1;
  face_index = 1;
  fid = fopen(filename,'rt');
  line = fgets(fid);
  while ischar(line)
    vertex = sscanf(line,'v %f %f %f');
    face = sscanf(line,'f %d %d %d');
    face_long = sscanf(line,'f %d//%d %d//%d %d//%d',6);
    face_long_long = sscanf(line,'f %d/%d/%d %d/%d/%d %d/%d/%d',9);

    % see if line is vertex command if so add to vertices
    if(size(vertex)>0)
      V(vertex_index,:) = vertex;
      vertex_index = vertex_index+1;
   % see if line is simple face command if so add to faces
    elseif(size(face,1)==3)
      F(face_index,:) = face;
      face_index = face_index+1;
    % see if line is a face with normal indices command if so add to faces
    elseif(size(face_long,1)==6)
      % remove normal
      face_long = face_long(1:2:end);
      F(face_index,:) = face_long;
      face_index = face_index+1;
    % see if line is a face with normal and texture indices command if so add to faces
    elseif(size(face_long_long,1)==9)
      % remove normal and texture indices
      face_long_long = face_long_long(1:3:end);
      F(face_index,:) = face_long_long;
      face_index = face_index+1;
    else
      fprintf('Ignored: %s',line);
    end

    line = fgets(fid);
  end
  fclose(fid);
end
