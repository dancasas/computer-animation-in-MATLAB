function incrementalWarpingForward()
    clc;clear;
    
    % points to click
    points = 3;
    
    % output gifs for warping animation
    gif_path_s_to_t = './output/source_to_target_forward_warp.gif';
    gif_path_t_to_s = './output/target_to_source_forward_warp.gif'; 
    gif_path_morphed = './output/morphed_forward_warp.gif'; 
    
    % loads image 1
    im1_original = imread('../test_images/triangleA.jpg');
    
    % rescales image 1 to 256x256
    im1(:,:,1) = imresize(im1_original(:,:,1), [256 256]); 
    im1(:,:,2) = imresize(im1_original(:,:,2), [256 256]); 
    im1(:,:,3) = imresize(im1_original(:,:,3), [256 256]); 
    
    % loads image 2 
    im2_original = imread('../test_images/triangleB.jpg');
    
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
    triangles = delaunay(x_mean, y_mean);
    
    % Shows triangulation
    figure;
    imagesc(im1);
    axis equal;
    hold on;
    triplot(triangles, x1, y1);
    hold off;
    
    figure;
    imagesc(im2);
    axis equal;
    hold on;
    triplot(triangles, x2, y2);
    hold off;
    
    % we are going to interpolate between im1 and im2 with 0.1 steps
    for t=0:0.1:1
        
        % allocates matrix to store warped images
        warp_src_to_target = zeros(256, 256, 3, 'uint8');
        warp_target_to_src = zeros(256, 256, 3, 'uint8');
      
        num_triangles = size(triangles, 1);
      
        % allocates memory to store the affine transformation per triangle
        affine_transf_src = zeros(3, 3, num_triangles);
        affine_transf_target = zeros(3, 3, num_triangles);
        
        % Find affine transformation of each triangle
        for tri=1:num_triangles
           %
           % !!!!!!!!!!! TO COMPLETE !!!!!!!!!!!!!!
           %
           % !! You must take into account that you need to find TWO transformation
           % !! matrices per triangle:
           % - a transformation to go from im1 to the 
           %   current interpolated point in time (affine_transf_src)
           % - a transformation to go from im2 to the 
           %   current interpolated point in time affine_transf_target
           %
        end

        % for all image pixels of the source image
        for i = 1:size(im1,1)
            for j = 1:size(im1,2)
                
                % computes triangles ID that contains pixel (i, j)
                tn = tsearchn([x1 y1], triangles, [i, j]);
                
                %
                % !!!!!!!!!!! TO COMPLETE !!!!!!!!!!!!!!
                %
                % !! You have to warp pixes from source image to the current interpolated
                % !! point (controlled by t) and store the result in warp_src_to_target
                %
            end
        end
        
        % for all image pixels of the target image
        for i = 1:size(im2,1)
            for j = 1:size(im2,2)
                % target to src
                tn = tsearchn([x2 y2], triangles, [i, j]);
                
                % !!!!!!!!!!! TO COMPLETE !!!!!!!!!!!!!!
                %
                % !! You have to warp pixes from target image to the current interpolated
                % !! point (controlled by t) and store the result in warp_target_to_src
                %
            end
        end
        
        % creates gif of source to target animation
        morphed = warp_src_to_target;
        [A, map] = rgb2ind(morphed, 256);
        if t == 0
            imwrite(A, map, gif_path_s_to_t, 'gif','LoopCount',...
                Inf,'DelayTime',0.1);
        else
            imwrite(A, map, gif_path_s_to_t, 'gif','WriteMode',...
                'append','DelayTime',0.1);
        end
        
        % creates gif of target to source animation
        morphed = warp_target_to_src;
        [A, map] = rgb2ind(morphed, 256);
        if t == 0
            imwrite(A, map, gif_path_t_to_s, 'gif','LoopCount',...
                Inf,'DelayTime',0.1);
        else
            imwrite(A, map, gif_path_t_to_s, 'gif','WriteMode',...
                'append','DelayTime',0.1);
        end
        
        % blends the morphed images and creates a gif
        %
        morphed = % !! TO COMPLETE! You have to linearly interpolate the warped images
        %
        
        [A, map] = rgb2ind(morphed, 256);
        if t == 0
            imwrite(A, map, gif_path_morphed, 'gif','LoopCount',...
                Inf,'DelayTime',0.1);
        else
            imwrite(A, map, gif_path_morphed, 'gif','WriteMode',...
                'append','DelayTime',0.1);
        end
        
    end
end
