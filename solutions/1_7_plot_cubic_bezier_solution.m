function 1_7_plot_cubic_bezier_solution()
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
    SAMPLES = 100;
    t = linspace(0,1,SAMPLES);
    pts =  kron((1-t).^3,pt1) +kron(((1-t).^2*3).*t,pt2) +  kron(3.*(t.^2).*(1-t),pt3) +kron(t.^3,pt4);
    plot(pts(1,:),pts(2,:),'LineWidth',2);
    
    hold off;
end
