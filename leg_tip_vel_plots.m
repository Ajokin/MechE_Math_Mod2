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
    
    % input the starting coordinates of the stranbeest
    vertex_coords = [
        15.0;   0.0;
       -38.0;  -7.8;
       -13.0;  35.0;
       -45.0;  25.0;
       -45.0; -25.0;
       -15.0; -40.0;
       -25.0; -85.0
    ];

    % loops through 1 rotation of the crank
    for i = 1:num_steps
        theta = theta_vals(i);
        
        % for the given theta, find the location of each vertex
        vertex_coords = compute_coords(vertex_coords, leg_params, theta);
        
        % wrapper function to put linkage_error_func in terms of vertices
        fun_V = @(V) linkage_error_func(V, leg_params, theta);

        % calculates jacobian of vertices
        J = approximate_jacobian(fun_V, vertex_coords);
        
        % calculates the error right before this theta and right after it
        dtheta = 1e-6; 
        F_plus = linkage_error_func(vertex_coords, leg_params, theta + dtheta);
        F_minus = linkage_error_func(vertex_coords, leg_params, theta - dtheta);
        
        % calculating average velocity before and after theta
        dFdtheta = (F_plus - F_minus) / (2 * dtheta);
        
        % velocity of tip
        dVdtheta_m1 = J \ (-dFdtheta);
        
        % calculates vertices before and after the theta
        V_plus = compute_coords(vertex_coords, leg_params, theta + dtheta);
        V_minus = compute_coords(vertex_coords, leg_params, theta - dtheta);
        
        % calculates the velocity at theta using finite differences method
        dVdtheta_m2 = (V_plus - V_minus) / (2 * dtheta);
        
        % extracts the velocity of vertex 7 at that theta
        dx_tip_m1(i) = dVdtheta_m1(13);
        dy_tip_m1(i) = dVdtheta_m1(14);
        
        dx_tip_m2(i) = dVdtheta_m2(13);
        dy_tip_m2(i) = dVdtheta_m2(14);
    end

    % latex plotter
    set(0, 'defaultTextInterpreter', 'latex');
    set(0, 'defaultAxesTickLabelInterpreter', 'latex');
    set(0, 'defaultLegendInterpreter', 'latex');
    
    fig = figure('Name', 'Leg Tip Velocity Comparison', 'Position', [100, 100, 1000, 800]);
    
    % horizontal velocity
    subplot(2, 1, 1);
    hold on; grid on;
    
    plot(theta_vals, dx_tip_m1, 'b-', 'LineWidth', 3, 'DisplayName', 'Method 1: Linear Algebra');
    plot(theta_vals, dx_tip_m2, 'r--', 'LineWidth', 2.5, 'DisplayName', 'Method 2: Finite Differences');
    
    title('Comparison of Horizontal Leg Tip Velocity ($\frac{dx_{tip}}{d\theta}$)', 'FontSize', 16);
    xlabel('Crank Angle $\theta$ (rad)', 'FontSize', 14);
    ylabel('Velocity $\frac{dx_{tip}}{d\theta}$ (-)', 'FontSize', 14);
    legend('Location', 'best', 'FontSize', 12); 
    
    % vertical velocity
    subplot(2, 1, 2);
    hold on; grid on;
    
    plot(theta_vals, dy_tip_m1, 'b-', 'LineWidth', 3, 'DisplayName', 'Method 1: Linear Algebra');
    plot(theta_vals, dy_tip_m2, 'r--', 'LineWidth', 2.5, 'DisplayName', 'Method 2: Finite Differences');
    
    title('Comparison of Vertical Leg Tip Velocity ($\frac{dy_{tip}}{d\theta}$)', 'FontSize', 16);
    xlabel('Crank Angle $\theta$ (rad)', 'FontSize', 14);
    ylabel('Velocity $\frac{dy_{tip}}{d\theta}$ (-)', 'FontSize', 14);
    legend('Location', 'best', 'FontSize', 12);
    
    exportgraphics(fig, 'Velocity_Comparison_Plot.png', 'Resolution', 600);

end