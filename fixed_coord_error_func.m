%Error function that encodes the fixed vertex constraints
%INPUTS:
%vertex_coords:a column vector containing the (x,y) coordinates of every vertex
% same input as link_length_error_func
%leg_params:a struct containing the parameters that describe the linkage
% importantly, leg_params.crank_length is the length of the crank
% and leg_params.vertex_pos0 and leg_params.vertex_pos2 are the
% fixed positions of the crank rotation center and vertex 2.
%theta:the current angle of the crank
%OUTPUTS:
%coord_errors: a column vector of height four corresponding to the differences
% between the current values of (x1,y1), (x2,y2) and
% the fixed values that they should be
function coord_errors = fixed_coord_error_func(vertex_coords, leg_params, theta)
          
    % contains the coordinates of each vertex
    coord_mat = reshape(vertex_coords, 2, [])';
    
    % extracts x1, y1, x2, and y2
    x1 = coord_mat(1, 1);
    y1 = coord_mat(1, 2);
    x2 = coord_mat(2, 1);
    y2 = coord_mat(2, 2);
    
    % unchanging location of vertex 2 (x2, y2)
    x2_bar = leg_params.vertex_pos2(1);
    y2_bar = leg_params.vertex_pos2(2);

    % location of vertex 0 (x1, y1)
    x1_bar = leg_params.vertex_pos0(1) + (leg_params.crank_length * cos(theta));
    y1_bar = leg_params.vertex_pos0(2) + (leg_params.crank_length * sin(theta));

    coord_errors = [x1 - x1_bar;
                   y1 - y1_bar;
                   x2 - x2_bar;
                   y2 - y2_bar];

end