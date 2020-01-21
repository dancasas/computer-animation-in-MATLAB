
function task_1_9_plot_bezier_equidistant_points_solution()
    figure();
    pt1 = [ 5;-10];
    pt2 = [9; 38];
    pt3 = [38; -5];
    pt4 = [45; 15];

    cla
    placelabel(pt1,'pt_1');
    placelabel(pt2,'pt_2');
    placelabel(pt3,'pt_3');
    placelabel(pt4,'pt_4');
    xlim([0 50]);
    ylim([-15 45])
    axis equal;
    
    hold on;
    grid on;
    SAMPLES = 18;
    t = linspace(0,1,SAMPLES);
    pts =  kron((1-t).^3,pt1) +kron(((1-t).^2*3).*t,pt2) +  kron(3.*(t.^2).*(1-t),pt3) +kron(t.^3,pt4);
    plot(pts(1,:),pts(2,:),'LineWidth',2);
    
    for k=1:size(pts,2)
        plot(pts(1,k),pts(2,k),'-o','Color',[1 0 0],...
        'MarkerSize',8,...
        'MarkerEdgeColor',[1 0 0],...
        'MarkerFaceColor',[1 0 0]);
    end
    hold off
    
    %% Compute Bezier curve length
    arc_length = compute_arc_length_cubic_bezier(pt1, pt2, pt3, pt4, 3);
    fprintf('ARC LENGTH   3 samples = %f\n', arc_length);
    
    arc_length = compute_arc_length_cubic_bezier(pt1, pt2, pt3, pt4, 7);
    fprintf('ARC LENGTH   7 samples = %f\n', arc_length);
    
    arc_length = compute_arc_length_cubic_bezier(pt1, pt2, pt3, pt4, 10);
    fprintf('ARC LENGTH  10 samples = %f\n', arc_length);    
    
    arc_length = compute_arc_length_cubic_bezier(pt1, pt2, pt3, pt4, 100);
    fprintf('ARC LENGTH 100 samples = %f\n', arc_length);
    
    arc_length = compute_arc_length_cubic_bezier(pt1, pt2, pt3, pt4, 400);
    fprintf('ARC LENGTH 400 samples = %f\n', arc_length);
    
     %% Equidistance points
    equidistance_points(pt1, pt2, pt3, pt4, 400);
    
end

function total_dist = compute_arc_length_cubic_bezier(pt1, pt2, pt3, pt4, samples)
    SAMPLES = samples;
    t       = linspace(0,1,SAMPLES);
    pts     = kron((1-t).^3,pt1) + kron(3*(1-t).^2.*t,pt2) + kron(3*(1-t).*t.^2,pt3) + kron(t.^3,pt4);
    
    total_dist = 0.0;
    for k=1:size(pts,2)-1
        dist = sqrt((pts(1,k+1)-pts(1,k))^2 + (pts(2,k+1)-pts(2,k))^2);
        total_dist = total_dist + dist;
        %fprintf('pts(%03d)-->pts(%03d) = %f\n', k, k+1, dist);
    end
    %fprintf('ARC LENGTH = %f\n', total_dist);
end

function equidistance_points(pt1, pt2, pt3, pt4, samples)
    figure;
    cla
    grid on
    placelabel(pt1,'pt_1');
    placelabel(pt2,'pt_2');
    placelabel(pt3,'pt_3');
    placelabel(pt4,'pt_4');    
    xlim([0 50]);
    ylim([-15 45]);
    axis equal
    hold on;
    
    total_dist = compute_arc_length_cubic_bezier(pt1, pt2, pt3, pt4, samples);
    
    SAMPLES = samples;
    t = linspace(0,1,SAMPLES);
    pts = kron((1-t).^3,pt1) + kron(3*(1-t).^2.*t,pt2) + kron(3*(1-t).*t.^2,pt3) + kron(t.^3,pt4);

    plot(pts(1,:),pts(2,:),'LineWidth',2);
    
    current_dist = 0.0;
    hits = 0;
    EQUIDISTANCE_POINTS = 18;
    update_target = 1;
    
    for k=1:size(pts,2)-1
       if(update_target == 1)
            target = (total_dist/EQUIDISTANCE_POINTS) * hits;
            update_target = 0;
       end
       
       dist = sqrt((pts(1,k+1)-pts(1,k))^2 + (pts(2,k+1)-pts(2,k))^2);
       current_dist = current_dist + dist;
       %fprintf('Current dist = %f     Target = %f\n', current_dist, target);
       if(target < current_dist)
            plot(pts(1,k),pts(2,k),'o','Color',[0 0 1],...
            'MarkerSize',8,...
            'MarkerEdgeColor','b',...
            'MarkerFaceColor','b');    
            hits = hits + 1;
            update_target = 1;
            %fprintf('Hits = %02d\n', hits);
       end
    end
    hold off;
end

function placelabel(pt,str)
    x = pt(1);
    y = pt(2);
    h = line(x,y);
    %scatter(x,y,'o');
    h.Marker = '*';
    h = text(x,y,str);
    
    h.HorizontalAlignment = 'center';
    h.VerticalAlignment = 'bottom';
end
  
