%Computes the vertex coordinates that describe a legal linkage configuration
%INPUTS:
%vertex_coords_guess: a column vector containing the (x,y) coordinates of every vertex
%                      these coords are just a GUESS! It's used to seed Newton's method
%leg_params: a struct containing the parameters that describe the linkage
%theta: the desired angle of the crank
%OUTPUTS:
%vertex_coords_root: a column vector containing the (x,y) coordinates of every vertex
%                    these coords satisfy all the kinematic constraints!
function vertex_coords_root = compute_coords(vertex_coords_guess, leg_params, theta)
    %your code here

    fun = @(x) linkage_error_func(x, leg_params, theta);

    % the default 1e-14 never gets hit here since the squared link lengths
    % are in the thousands (round off keeps |f| around 1e-12), so newton was
    % running all 200 iterations on most frames. 1e-10 is still really accurate
    solver_params = struct();
    solver_params.ftol = 1e-10;
    solver_params.dxmin = 1e-10;

    [vertex_coords_root, ~] = multi_newton_solver(fun, vertex_coords_guess, solver_params);

    %you will likely need to make a wrapper function of linkage_error_func
    %so that it is only a function of vertex_coords 
    %(and not leg_params or theta, which should be set beforehand)
    %you can then pass this wrapper function to your multidimensional Newton
    %solver, along with vertex_coords_guess to find the vertex coordinates
    %corresponding to the legal configuration of the linkage, 
    %given the values set for leg_params and theta
end
