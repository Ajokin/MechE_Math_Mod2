%Computes the theta derivatives of each vertex coordinate for the Jansen linkage
%INPUTS:
%vertex_coords: a column vector containing the (x,y) coordinates of every vertex
%               these are assumed to be legal values that are roots of the error funcs!
%leg_params: a struct containing the parameters that describe the linkage
%theta: the current angle of the crank
%OUTPUTS:
%dVdtheta: a column vector containing the theta derivates of each vertex coord
function dVdtheta = compute_velocities(vertex_coords, leg_params, theta)
    % jacobian of just the link length errors (10x14), done numerically
    % with approximate_jacobian from day 6
    length_fun = @(V) link_length_error_func(V, leg_params);
    J = approximate_jacobian(length_fun, vertex_coords);

    % vertex 1 rides around the crank circle and vertex 2 is pinned, so
    % their theta derivatives are already known
    dx1_dtheta = -leg_params.crank_length * sin(theta);
    dy1_dtheta = leg_params.crank_length * cos(theta);

    % fixed vertex rows go on top of J to make M (14x14), and B is the
    % known derivatives followed by a zero for every link
    num_coords = 2*leg_params.num_vertices;
    M = [eye(4), zeros(4, num_coords - 4); J];
    B = [dx1_dtheta; dy1_dtheta; 0; 0; zeros(leg_params.num_linkages, 1)];

    % solving M*dVdtheta = B, backslash instead of inv(M) like before
    dVdtheta = M\B;
end
