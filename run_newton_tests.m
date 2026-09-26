% runs all the tests for Parts 3 to 5
% checks approximate_jacobian against the analytical Jacobian, then tries
% multi_newton_solver on test_function01, test_function02, and the
% projectile/target problem (animation plays at the end)

% Part 3: numerical vs analytical Jacobian of test_function01
X_test = [1;2;3];
[~,J_analytical] = test_function01(X_test);
J_numerical = approximate_jacobian(@test_function01,X_test);

disp('analytical Jacobian at [1;2;3]:')
disp(J_analytical)
disp('numerical Jacobian at [1;2;3]:')
disp(J_numerical)
fprintf('largest difference between the two: %.2e\n',max(max(abs(J_numerical-J_analytical))));

% test suite from canvas
test_numerical_jacobian(@approximate_jacobian);

% Part 5: test_function01 from a few guesses, each one lands on a
% different root (x1+x2+x3 ends up as a different multiple of pi)
disp('multi_newton_solver on test_function01:')
print_solver_test(@test_function01,[1;2;3]);
print_solver_test(@test_function01,[4;4;2]);
print_solver_test(@test_function01,[3;3;2]);

% x1 = x2 and x3 = 1 makes the first two columns of J the same, so J is
% singular here on purpose. should get caught by the det check
print_solver_test(@test_function01,[1;1;1]);

% test_function02 has 2 outputs and 3 inputs so there's a whole curve of
% roots (where the ellipsoid and the plane cross), which one we get
% depends on the guess
disp(' ')
disp('multi_newton_solver on test_function02:')
print_solver_test(@test_function02,[1;1;1]);
print_solver_test(@test_function02,[5;5;5]);

% gradient of f1 is zero at the origin so the top row of J is all zeros,
% should also get caught by the det check
print_solver_test(@test_function02,[0;0;0]);

% projectile: wrapper makes it one function of V = [theta;t] that's zero
% when the projectile and the target are in the same spot
collision_fun = @(V) projectile_traj(V(1),V(2)) - target_traj(V(2));

% guess 45 degrees and 3 seconds. there's no analytical J for this one so
% it uses the numerical one (the default)
V_guess = [pi/4;3];
[V_root,flag_proj] = multi_newton_solver(collision_fun,V_guess);
theta = V_root(1);
t_c = V_root(2);

disp(' ')
fprintf('projectile: flag %d, theta = %.6f rad (%.2f deg), t_c = %.6f s\n', ...
    flag_proj,theta,theta*180/pi,t_c);
fprintf('distance between projectile and target at t_c: %.2e m\n',norm(collision_fun(V_root)));

figure();
projectile_simulation(theta,t_c);


%runs multi_newton_solver on fun from X_guess with both Jacobian options
%and prints what it found (only set up for 3 inputs)
function print_solver_test(fun,X_guess)
    analytical_params = struct();
    analytical_params.numerical_diff = 0;

    [X_a,flag_a] = multi_newton_solver(fun,X_guess,analytical_params);
    [X_n,flag_n] = multi_newton_solver(fun,X_guess);

    fprintf('guess [%g;%g;%g]\n',X_guess(1),X_guess(2),X_guess(3));
    fprintf('  analytical J: flag %d, X = [%.6f; %.6f; %.6f], |f(X)| = %.2e\n', ...
        flag_a,X_a(1),X_a(2),X_a(3),norm(fun(X_a)));
    fprintf('  numerical J:  flag %d, X = [%.6f; %.6f; %.6f], |f(X)| = %.2e\n', ...
        flag_n,X_n(1),X_n(2),X_n(3),norm(fun(X_n)));
end
