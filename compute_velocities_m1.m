% Computes the theta derivatives of each vertex coordinate for the Jansen linkage
%INPUTS:
% vertex_coords: a column vector containing the (x,y) coordinates of every vertex
% these are assumed to be legal values that are roots of the error funcs!
% leg_params: a struct containing the parameters that describe the linkage
% theta: the current angle of the crank
%OUTPUTS:
% dVdtheta: a column vector containing the theta derivatives of each vertex coord
function dVdtheta = compute_velocities_m1(vertex_coords, leg_params, theta)
    % Step 1: Calculate the Jacobian matrix dF/dV
    % Create an anonymous function where V is the only input
    fun_V = @(V) linkage_error_func(V, leg_params, theta);
    
    % Use the provided finite difference function to get the Jacobian
    J = approximate_jacobian(fun_V, vertex_coords);
    
    % Step 2: Calculate the partial derivative dF/dtheta
    % Use a small step size for finite differences
    dtheta = 1e-6; 
    
    % Evaluate the error function at theta + dtheta and theta - dtheta
    F_plus = linkage_error_func(vertex_coords, leg_params, theta + dtheta);
    F_minus = linkage_error_func(vertex_coords, leg_params, theta - dtheta);
    
    % Compute the central difference vector
    dFdtheta = (F_plus - F_minus) / (2 * dtheta);
    
    % Step 3: Solve the linear system J * dVdtheta = -dFdtheta
    % Using the backslash operator for numerical stability
    dVdtheta = J \ (-dFdtheta);
end