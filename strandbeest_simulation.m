%runs strandbeest simulation
function strandbeest_simulation()
    close all;
    leg_params = define_leg_parameters();

    leg_drawing = initialize_leg_drawing(leg_params);

    mypath1 = 'C:\Users\akutuva\Documents\GitHub\MechE_Math_Mod2\';
    fname = 'strandbeest_animation.avi';
    input_fname = [mypath1, fname];

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

    num_steps = 400;    
    theta_array = linspace(0,6*pi(), num_steps);
    current_coords = vertex_coords_guess;

    for i = 1:num_steps
        theta = theta_array(i);
        current_coords = compute_coords(current_coords, leg_params, theta);
        update_leg_drawing(current_coords, leg_drawing, leg_params);
        drawnow;

        % Capture the current figure
        current_frame = getframe(leg_drawing.fig);

        % Write the frame to the video
        writeVideo(writerObj, current_frame);
    end

    % Close the video
    close(writerObj);
end