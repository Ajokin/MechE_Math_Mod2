% Compares the leg shape that newton lands on from two different initial guesses
% both shapes satisfy all 14 constraints, but only the first one is the
% walking leg from the animation. the second guess is the one our first
% velocity plots used, and newton folds vertex 5 over next to vertex 2
%INPUTS:
%   None
%OUTPUTS:
%   None (saves the figure one folder up, outside the repo, for the report)
function compare_leg_guesses()
    leg_params = define_leg_parameters();

    % guess from the assignment (same one strandbeest_simulation uses)
    guess_walking = [0;50; -50;0; -50;50; -100;0; -100;-50; -50;-50; -50;-100];

    % guess from our first version of leg_tip_vel_plots
    guess_folded = [15;0; -38;-7.8; -13;35; -45;25; -45;-25; -15;-40; -25;-85];

    guesses = {guess_walking, guess_folded};
    plot_titles = {'Walking leg (guess from the assignment)', ...
                   'Folded leg (guess from our first velocity plots)'};

    fig = figure('Color', 'w', 'Position', [100, 100, 1700, 850]);

    for k = 1:2
        % solve at theta = 0, then follow it around one turn for the foot path
        coords_0 = compute_coords(guesses{k}, leg_params, 0);
        theta_list = linspace(0, 2*pi, 200);
        foot_path = zeros(2, length(theta_list));
        current_coords = coords_0;
        for i = 1:length(theta_list)
            current_coords = compute_coords(current_coords, leg_params, theta_list(i));
            foot_path(:, i) = current_coords(13:14);
        end

        % biggest constraint error at theta = 0, both should basically be zero
        max_error = max(abs(linkage_error_func(coords_0, leg_params, 0)));
        fprintf('%s: max constraint error = %.2e\n', plot_titles{k}, max_error);

        % [x,y] rows so each vertex is just coords(i,:)
        coords = column_to_matrix(coords_0);

        subplot(1, 2, k);
        hold on; axis equal; box on; grid on;

        path_plot = plot(foot_path(1, :), foot_path(2, :), 'b--', 'LineWidth', 2);
        for link = 1:leg_params.num_linkages
            a = leg_params.link_to_vertex_list(link, 1);
            b = leg_params.link_to_vertex_list(link, 2);
            link_plot = plot(coords([a, b], 1), coords([a, b], 2), 'k', 'LineWidth', 2.5);
        end
        crank_plot = plot([0, coords(1, 1)], [0, coords(1, 2)], 'Color', [0.5 0.5 0.5], 'LineWidth', 2.5);
        vertex_plot = plot(coords(:, 1), coords(:, 2), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 9);

        % number each vertex so it's easy to see which one flipped. in the
        % folded leg vertex 5 ends up right next to vertex 2, so its label
        % goes on the other side so they don't overlap
        label_dx = 3*ones(leg_params.num_vertices, 1);
        label_dy = 4*ones(leg_params.num_vertices, 1);
        if k == 2
            label_dx(5) = -10;
            label_dy(5) = -6;
        end
        for v = 1:leg_params.num_vertices
            text(coords(v, 1) + label_dx(v), coords(v, 2) + label_dy(v), num2str(v), 'Color', 'r', ...
                'FontSize', 16, 'Interpreter', 'latex');
        end

        axis([-125, 40, -110, 50]);
        title({plot_titles{k}, sprintf('max constraint error = %.1e', max_error)}, ...
            'Interpreter', 'latex', 'FontSize', 18);
        xlabel('Horizontal position, $x$ (-)', 'Interpreter', 'latex');
        ylabel('Vertical position, $y$ (-)', 'Interpreter', 'latex');
        set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 15);
        legend([link_plot, crank_plot, vertex_plot, path_plot], ...
            {'Links', 'Crank', 'Vertices', 'Foot path (one crank turn)'}, ...
            'Interpreter', 'latex', 'Location', 'northwest', 'FontSize', 13);
    end

    % real png instead of a screenshot, one folder up so it stays out of the repo
    fig_dir = fullfile(fileparts(fileparts(mfilename('fullpath'))), 'Assignment 2 Report Figures');
    if ~exist(fig_dir, 'dir')
        mkdir(fig_dir);
    end
    exportgraphics(fig, fullfile(fig_dir, 'leg_guess_comparison.png'), 'Resolution', 300);
end
