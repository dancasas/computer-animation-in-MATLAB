function 2_3_incremental_warp_backward_solution()
    clc;
    clear;
    
    % points to click
    points = 3;
    
    % output gif for warping animation
    gif_path_s_to_t = './output/source_to_target_backward_warp.gif';
    gif_path_t_to_s = './output/target_to_source_backward_warp.gif'; 
    gif_path_morphed = './output/morphed_backward_warp.gif';  
    
    % loads image 1
    im1_original = imread('../data/test_images/triangleA2.jpg');
    
    % rescales image 1 to 256x256
    im1(:,:,1) = imresize(im1_original(:,:,1), [256 256]); 
    im1(:,:,2) = imresize(im1_original(:,:,2), [256 256]); 
    im1(:,:,3) = imresize(im1_original(:,:,3), [256 256]); 
    
    % loads image 2 
    im2_original = imread('../data/test_images/triangleB2.jpg');
    
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

    % Computes triangulation using Delauny at the mid point
    x_mean = (x1 + x2) / 2;
    y_mean = (y1 + y2) / 2;
    triangles1 = delaunay(x_mean, y_mean);
    
    % Show triangulation
    figure;
    imagesc(im1);
    axis equal;
    hold on;
    triplot(triangles1, x1, y1);
    hold off;
    
    figure;
    imagesc(im2);
    axis equal;
    hold on;
    triplot(triangles1, x2, y2);
    hold off;
    
    for t=0:0.1:1
        % allocates matrix to store warped images
        warp_src_to_target = zeros(256, 256, 3, 'uint8');
        warp_target_to_src = zeros(256, 256, 3, 'uint8');
        
        num_triangles = size(triangles1, 1);
        
        % allocates memory to store the affine transformation per triangle
        affine_transf_src = zeros(3, 3, num_triangles);
        affine_transf_target = zeros(3, 3, num_triangles);
        
        % Find affine transformation of each triangle
        for tri=1:num_triangles
           fprintf('Triangle %d\n',tri)
           tri_vertices = triangles1(tri, :);

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
           
           % Interpolated triangles
           tri_interp = [(v1_src * (1-t) + v1_target * t) ... 
                         (v2_src * (1-t) + v2_target * t) ...
                         (v3_src * (1-t) + v3_target * t) ];
           
           % Computes affine transformation
           affine_transf_src(:,:,tri) = tri_interp * inv(tri_src);
           affine_transf_target(:,:,tri) = tri_interp * inv(tri_target);
        end

        for i = 1:size(im1,1)
            for j = 1:size(im1,2)
                
                % src to target
                % computes triangles ID that contains pixel (i, j)
                x_current = x1 * (1-t) + x2 * t;
                y_current = y1 * (1-t) + y2 * t;
                tn = tsearchn([x_current y_current], triangles1, [i, j]);
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
        for i = 1:size(im2,1)
            for j = 1:size(im2,2)
                % target to src
                x_current = x1 * (1-t) + x2 * t;
                y_current = y1 * (1-t) + y2 * t;
                tn = tsearchn([x_current y_current], triangles1, [i, j]);
                target = round(inv(affine_transf_target(:,:,tn)) * [i j 1]');
                
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
                warp_target_to_src(j,i,1) = im2(target(2),target(1),1);
                warp_target_to_src(j,i,2) = im2(target(2),target(1),2);
                warp_target_to_src(j,i,3) = im2(target(2),target(1),3);
            end
        end
        
        morphed = warp_src_to_target;
        %imagesc(morphed);
        [A, map] = rgb2ind(morphed, 256);
        %A = fillmissing(A,'nearest');
        if t == 0
            imwrite(A, map, gif_path_s_to_t, 'gif','LoopCount',...
                Inf,'DelayTime',0.1);
        else
            imwrite(A, map, gif_path_s_to_t, 'gif','WriteMode',...
                'append','DelayTime',0.1);
        end
        
        
        morphed = warp_target_to_src;
        %imagesc(morphed);
        [A, map] = rgb2ind(morphed, 256);
        if t == 0
            imwrite(A, map, gif_path_t_to_s, 'gif','LoopCount',...
                Inf,'DelayTime',0.1);
        else
            imwrite(A, map, gif_path_t_to_s, 'gif','WriteMode',...
                'append','DelayTime',0.1);
        end
        
        morphed = t * warp_target_to_src + (1 - t) * warp_src_to_target;
        
        % if we want to show the triangular mesh over the warp gif that is
        % saved out
        WRITE_TRIANGULAR_MESH = 1;
        
        if WRITE_TRIANGULAR_MESH == 1
            h = figure('visible', 'off');
            a = axes('parent', h);
            imagesc(morphed);
            axis equal;
            hold on;
            triplot(triangles1,((x1 * (1-t)) + (x2 * t)), ((y1 * (1-t)) + (y2 * t)),'LineWidth',2,'Color','green');
            hold off;
            content = frame2im(getframe(h));

            close(h);
            [A, map] = rgb2ind(content, 256);
        else
            [A, map] = rgb2ind(morphed, 256);
        end
            
        %imagesc(morphed);
        
        if t == 0
            imwrite(A, map, gif_path_morphed, 'gif','LoopCount',...
                Inf,'DelayTime',0.1);
        else
            imwrite(A, map, gif_path_morphed, 'gif','WriteMode',...
                'append','DelayTime',0.1);
        end
        

    end
    
    figure;
    imagesc(warp_src_to_target);
    axis equal;
    hold on;
    triplot(triangles1,x2,y2);
    hold off;
    
    figure;
    imagesc(warp_target_to_src);
    axis equal;
    hold on;
    triplot(triangles1,x1,y1);
    hold off;
    
    figure;
    alpha = 0.5;
    morphed = alpha * warp_target_to_src + (1 - alpha) * warp_src_to_target;
    imagesc(morphed);
    title('Blend warped');
    axis equal;
    
    figure;
    alpha = 0.5;
    morphed = alpha * im1 + (1 - alpha) * im2;
    imagesc(morphed);
    title('Blend linear');
    axis equal;
end
