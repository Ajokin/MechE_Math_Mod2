%runs strandbeest simulation
function strandbeest_simulation()
    close all;
    leg_params = define_leg_parameters();

    leg_drawing = initialize_leg_drawing(leg_params);

    % saves the video one folder up (right outside the repo) so it works on
    % everyone's computer. the 4k version is also over github's 100 MB limit
    mypath1 = fileparts(fileparts(mfilename('fullpath')));
    fname = 'strandbeest_animation.avi';
    input_fname = fullfile(mypath1, fname);

    writerObj = VideoWriter(input_fname);
    writerObj.FrameRate = 60;
    open(writerObj);

    %column vector of initial guesses
    %for each vertex location.
    %in form: [x1;y1;x2;y2;...;xn;yn]
    vertex_coords_guess = [...
    [   0;   50];... %vertex 1 guess
    [ -50;    0];... %vertex 2 guess
    [ -50;   50];... %vertex 3 guess 
    [-100;    0];... %vertex 4 guess
    [-100;  -50];... %vertex 5 guess
    [ -50;  -50];... %vertex 6 guess
    [ -50; -100]...  %vertex 7 guess  
    ];

    num_steps = 700;    
    theta_array = linspace(0,10*pi(), num_steps);
    current_coords = vertex_coords_guess;

    % Pre-allocate coordinate history for vertex 7
    x7_path = zeros(1, num_steps);
    y7_path = zeros(1, num_steps);

    % dV/dtheta is pretty big so the arrow gets scaled down to stay readable
    velocity_scale = 0.5;

    for i = 1:num_steps
        theta = theta_array(i);
        current_coords = compute_coords(current_coords, leg_params, theta);

        % Store current position of vertex 7
        x7_path(i) = current_coords(2*7 - 1);
        y7_path(i) = current_coords(2*7);

        % foot velocity from compute_velocities. theta only goes up over
        % time so this points the way the foot is actually moving
        dVdtheta = compute_velocities(current_coords, leg_params, theta);
        foot_velocity = velocity_scale * [dVdtheta(2*7 - 1); dVdtheta(2*7)];

        update_leg_drawing(current_coords, leg_drawing, leg_params, x7_path(1:i), y7_path(1:i), foot_velocity);
        drawnow;

        % Capture the current figure
        current_frame = getframe(leg_drawing.fig);

        % Write the frame to the video
        writeVideo(writerObj, current_frame);
    end

    % Close the video
    close(writerObj);
end