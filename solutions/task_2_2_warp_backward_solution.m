function task_2_2_wrap_backward_solution()
    clc;clear;
     
    % points to click
    points = 3;
     
    % loads image 1
    im1_original = imread('../data/test_images/triangleA.jpg');
     
    % rescales image 1 to 256x256
    im1(:,:,1) = imresize(im1_original(:,:,1), [256 256]);
    im1(:,:,2) = imresize(im1_original(:,:,2), [256 256]);
    im1(:,:,3) = imresize(im1_original(:,:,3), [256 256]);
     
    % loads image 2
    im2_original = imread('../data/test_images/triangleB.jpg');
     
    % rescales image 1 to 256x256
    im2(:,:,1) = imresize(im2_original(:,:,1), [256 256]);
    im2(:,:,2) = imresize(im2_original(:,:,2), [256 256]);
    im2(:,:,3) = imresize(im2_original(:,:,3), [256 256]);
     
    figure;
    imagesc(im1);
    axis equal;
    hold on;
    [x1,y1] = ginput(points);
     
    % Appends points (1,1), (1,256), (256,1), and (256,256) to the clicked
    % points. This is needed for a Delauny triangulation that affects the
    % entire image
    x1 = vertcat(x1, 1, 1, 256, 256);
    y1 = vertcat(y1, 1, 256, 1, 256);
    fprintf('x1: %.5f , y1: %.5f\n',x1(1), y1(1));
    fprintf('x1: %.5f , y1: %.5f\n',x1(2), y1(2));
    fprintf('x1: %.5f , y1: %.5f\n',x1(3), y1(3));
    hold off;
     
    figure;
    imagesc(im2);
    axis equal;
    hold on;
    [x2,y2] = ginput(points);
    x2 = vertcat(x2, 1, 1, 256, 256);
    y2 = vertcat(y2, 1, 256, 1, 256);
    fprintf('x2: %.5f , y2: %.5f\n',x2(1), y2(1));
    fprintf('x2: %.5f , y2: %.5f\n',x2(2), y2(2));
    fprintf('x2: %.5f , y2: %.5f\n',x2(3), y2(3));
    hold off;
     
    close all
 
    % Computes triangulation at mid point using Delauny
    x_mean = (x1 + x2) / 2;
    y_mean = (y1 + y2) / 2;
    triangles = delaunay(x_mean, y_mean);
     
    % Show triangulation
    figure;
    imagesc(im1);
    axis equal;
    hold on;
    triplot(triangles, x1, y1);
    title('Source');
    hold off;
     
    figure;
    imagesc(im2);
    axis equal;
    hold on;
    triplot(triangles, x2, y2);
    title('Target');
    hold off;
     
    num_triangles = size(triangles, 1);
    warp_src_to_target = zeros(256, 256, 3, 'uint8');
    affine_transf_src = zeros(3, 3, num_triangles);
     
    % Find affine transformation of each triangle
    for tri=1:size(triangles, 1)
        fprintf('Triangle %d\n',tri)
        tri_vertices = triangles(tri, :);
 
        % retreives vertex positions of the triangle in image 1 (source)
        v1_src = [x1(tri_vertices(1)) y1(tri_vertices(1)) 1]'; 
        v2_src = [x1(tri_vertices(2)) y1(tri_vertices(2)) 1]'; 
        v3_src = [x1(tri_vertices(3)) y1(tri_vertices(3)) 1]'; 
 
        % retreives vertex positions of the triangle in image 2 (target)
        v1_target = [x2(tri_vertices(1)) y2(tri_vertices(1)) 1]'; 
        v2_target = [x2(tri_vertices(2)) y2(tri_vertices(2)) 1]'; 
        v3_target = [x2(tri_vertices(3)) y2(tri_vertices(3)) 1]';
 
 
        tri_src = [v1_src v2_src v3_src];
        tri_target = [v1_target v2_target v3_target];
 
        % Computes affine transformation
        affine_transf_src(:,:,tri) = tri_target * inv(tri_src);
    end
     
    % warps all pixels im im1 using the affine transformation of the
    % triangle they belong to
    for i = 1:size(im1,1)
        for j = 1:size(im1,2)
 
            % src to target
            % computes triangles ID that contains pixel (i, j)
            tn = tsearchn([x2 y2], triangles, [i, j]);
            target = round(inv(affine_transf_src(:,:,tn)) * [i j 1]');
 
            if target(1) <= 0
                target(1) = 1;
            end
            if target(2) <= 0
                target(2) = 1;
            end
            if target(1) > 256
                target(1) = 256;
            end
            if target(2) > 256
                target(2) = 256;
            end
 
            warp_src_to_target(j,i,1) = im1(target(2),target(1),1);
            warp_src_to_target(j,i,2) = im1(target(2),target(1),2);
            warp_src_to_target(j,i,3) = im1(target(2),target(1),3);
        end
    end
     
    figure;
    imagesc(warp_src_to_target);
    hold on;
    triplot(triangles, x2, y2);
    title('Source to target');
    hold off;
    axis equal;
end
