%runs strandbeest simulation
function strandbeest_simulation()

    leg_params = define_leg_parameters();

    leg_drawing = initialize_leg_drawing(leg_params);

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


    % length_errors = link_length_error_func(vertex_coords_guess, leg_params);
    % coord_errors = fixed_coord_error_func(vertex_coords_guess, leg_params, 0);

    num_steps = 200;    
    theta_array = linspace(0,2*pi(), num_steps);
    current_coords = vertex_coords_guess;

    for i = 1:num_steps
        theta = theta_array(i);
        current_coords = compute_coords(current_coords, leg_params, theta);
        update_leg_drawing(current_coords, leg_drawing, leg_params);
        drawnow;
    end

    %your code here
    %this code will likely involve a loop, where you call
    %compute_coords at each iteration
    %you likely will also need to call update_leg_drawing each iteration
end