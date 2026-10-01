% Computes the theta derivatives of each vertex coordinate for the Jansen
% linkage using the finite differences method
%INPUTS:
% vertex_coords: a column vector containing the (x,y) coordinates of every vertex
% these are assumed to be legal values that are roots of the error funcs!
% leg_params: a struct containing the parameters that describe the linkage
% theta: the current angle of the crank
%OUTPUTS:
% dVdtheta: a column vector containing the theta derivatives of each vertex coord
function dVdtheta = compute_velocities_m2(vertex_coords, leg_params, theta)
    % Step 1: Define a very small step size for the crank angle
    dtheta = 1e-6; 
    
    % Step 2: Find the exact valid vertex coordinates at theta + dtheta
    % We pass the current vertex_coords as the "guess" because the 
    % new position will be extremely close to the current one.
    V_plus = compute_coords(vertex_coords, leg_params, theta + dtheta);
    
    % Step 3: Find the exact valid vertex coordinates at theta - dtheta
    V_minus = compute_coords(vertex_coords, leg_params, theta - dtheta);
    
    % Step 4: Compute the finite difference derivative
    dVdtheta = (V_plus - V_minus) / (2 * dtheta);
end