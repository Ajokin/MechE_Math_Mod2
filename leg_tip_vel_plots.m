% Creates plots for the leg tip velocity using the two computation methods
%INPUTS:
%   None (The function simulates the rotation and calculates data internally)
%OUTPUTS:
%   None (Generates and saves a high-resolution plot)
function leg_tip_vel_plots()
    close all;

    % get leg parameters
    leg_params = define_leg_parameters();
    
    % 100 steps per full rotation of crank
    num_steps = 100;
    theta_vals = linspace(0, 2*pi, num_steps);
    
    % preallocate space for velocity in x and y direction for method 1 and
    % 2
    dx_tip_m1 = zeros(1, num_steps);
    dy_tip_m1 = zeros(1, num_steps);
    dx_tip_m2 = zeros(1, num_steps);
    dy_tip_m2 = zeros(1, num_steps);
    
    % input the starting coordinates of the strandbeest
    % using the same guess as strandbeest_simulation now. the guess we had
    % here before also satisfied every constraint, but newton landed on a
    % flipped version of the leg (vertex 5 folds in next to vertex 2), so
    % the plots weren't for the same leg as the animation
    vertex_coords = [...
    [   0;   50];... %vertex 1 guess
    [ -50;    0];... %vertex 2 guess
    [ -50;   50];... %vertex 3 guess
    [-100;    0];... %vertex 4 guess
    [-100;  -50];... %vertex 5 guess
    [ -50;  -50];... %vertex 6 guess
    [ -50; -100]...  %vertex 7 guess
    ];

    % loops through 1 rotation of the crank
    for i = 1:num_steps
        theta = theta_vals(i);
        
        % for the given theta, find the location of each vertex
        vertex_coords = compute_coords(vertex_coords, leg_params, theta);
        
        % method 1: linear algebra, solves M*dVdtheta = B inside
        % compute_velocities
        dVdtheta_m1 = compute_velocities(vertex_coords, leg_params, theta);

        % method 2: wrapper so compute_coords is only a function of theta,
        % then approximate_jacobian does the finite difference for us
        % (central difference with the same 1e-6 step)
        coords_of_theta = @(th) compute_coords(vertex_coords, leg_params, th);
        dVdtheta_m2 = approximate_jacobian(coords_of_theta, theta);
        
        % extracts the velocity of vertex 7 at that theta
        dx_tip_m1(i) = dVdtheta_m1(13);
        dy_tip_m1(i) = dVdtheta_m1(14);
        
        dx_tip_m2(i) = dVdtheta_m2(13);
        dy_tip_m2(i) = dVdtheta_m2(14);
    end

    % how far apart the two methods are (for the report)
    fprintf('largest difference in dx_tip/dtheta: %.2e\n', max(abs(dx_tip_m1 - dx_tip_m2)));
    fprintf('largest difference in dy_tip/dtheta: %.2e\n', max(abs(dy_tip_m1 - dy_tip_m2)));

    % latex plotter
    set(0, 'defaultTextInterpreter', 'latex');
    set(0, 'defaultAxesTickLabelInterpreter', 'latex');
    set(0, 'defaultLegendInterpreter', 'latex');
    
    fig = figure('Name', 'Leg Tip Velocity Comparison', 'Position', [100, 100, 1000, 800]);
    
    % horizontal velocity
    subplot(2, 1, 1);
    hold on; grid on;
    xlim([0 2*pi])
    
    plot(theta_vals, dx_tip_m1, 'b-', 'LineWidth', 3, 'DisplayName', 'Method 1: Implicit Method');
    plot(theta_vals, dx_tip_m2, 'r--', 'LineWidth', 2.5, 'DisplayName', 'Method 2: Finite Differences');
    
    title('Comparison of Horizontal Leg Tip Velocity $\left(\frac{dx_{tip}}{d\theta}\right)$', 'FontSize', 16);
    xlabel('Crank Angle $\theta$ (rad)', 'FontSize', 14);
    ylabel('Velocity $\left(\frac{dx_{tip}}{d\theta}\right)$ (-)', 'FontSize', 14);
    % 'best' put this one on top of the curve coming back up near theta = 4,
    % the bottom left corner is empty for this plot
    legend('Location', 'southwest', 'FontSize', 12);
    
    % vertical velocity
    subplot(2, 1, 2);
    hold on; grid on;
    xlim([0 2*pi])
    
    plot(theta_vals, dy_tip_m1, 'b-', 'LineWidth', 3, 'DisplayName', 'Method 1: Implicit Method');
    plot(theta_vals, dy_tip_m2, 'r--', 'LineWidth', 2.5, 'DisplayName', 'Method 2: Finite Differences');
    
    title('Comparison of Vertical Leg Tip Velocity $\left(\frac{dy_{tip}}{d\theta}\right)$', 'FontSize', 16);
    xlabel('Crank Angle $\theta$ (rad)', 'FontSize', 14);
    ylabel('Velocity $\left(\frac{dy_{tip}}{d\theta}\right)$ (-)', 'FontSize', 14);
    legend('Location', 'northwest', 'FontSize', 12);
    
    exportgraphics(fig, 'Velocity_Comparison_Plot.png', 'Resolution', 600);
end