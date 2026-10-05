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

% figures for the report, saved one folder up so they don't end up in the repo
fig_dir = fullfile(fileparts(fileparts(mfilename('fullpath'))),'Assignment 2 Report Figures');
if ~exist(fig_dir,'dir')
    mkdir(fig_dir);
end

% |f| after every newton step from [1;2;3] with both Jacobian options, to
% see if the error really drops quadratically (digits roughly doubling)
num_steps = 7;
f_hist_a = zeros(1,num_steps+1);
f_hist_n = zeros(1,num_steps+1);
X_a = [1;2;3];
X_n = [1;2;3];
f_hist_a(1) = norm(test_function01(X_a));
f_hist_n(1) = norm(test_function01(X_n));
for n = 1:num_steps
    [F,J] = test_function01(X_a);
    X_a = X_a - J\F;
    f_hist_a(n+1) = norm(test_function01(X_a));

    F = test_function01(X_n);
    J = approximate_jacobian(@test_function01,X_n);
    X_n = X_n - J\F;
    f_hist_n(n+1) = norm(test_function01(X_n));
end
disp(' ')
disp('|f| after each step (analytical J):')
disp(f_hist_a)

fig1 = figure('Color','w','Position',[100,100,1000,650]);
semilogy(0:num_steps,f_hist_a,'b-o','LineWidth',3,'MarkerFaceColor','b','MarkerSize',8, ...
    'DisplayName','Analytical Jacobian');
hold on;
semilogy(0:num_steps,f_hist_n,'r--s','LineWidth',2,'MarkerSize',10, ...
    'DisplayName','Numerical Jacobian (approximate\_jacobian)');
grid on; box on;
xlabel('Newton iteration, $n$ (-)','Interpreter','latex');
ylabel('Error magnitude, $|f(X_n)|$ (-)','Interpreter','latex');
title('Convergence of Newton''s Method on test\_function01 from $X_0 = [1;2;3]$','Interpreter','latex');
set(gca,'TickLabelInterpreter','latex','FontSize',16);
legend('Interpreter','latex','Location','northeast','FontSize',14);
exportgraphics(fig1,fullfile(fig_dir,'newton_convergence.png'),'Resolution',300);

% still picture of the hit for the report, paths up to t_c and where the
% projectile and target both are at t_c
t_list = linspace(0,t_c,300);
proj_path = projectile_traj(theta,t_list);
targ_path = target_traj(t_list);
hit_point = projectile_traj(theta,t_c);

fig2 = figure('Color','w','Position',[100,100,900,850]);
hold on; axis equal; box on; grid on;
plot(proj_path(1,:),proj_path(2,:),'g--','LineWidth',3,'DisplayName','Projectile path');
plot(targ_path(1,:),targ_path(2,:),'k--','LineWidth',2,'DisplayName','Target path');
plot(proj_path(1,1),proj_path(2,1),'gs','MarkerFaceColor','g','MarkerSize',10,'DisplayName','Launch point');
plot(hit_point(1),hit_point(2),'ro','MarkerFaceColor','r','MarkerSize',12, ...
    'DisplayName',sprintf('Collision at $t_c$ = %.3f s',t_c));
axis([0,50,0,50]);
xlabel('Horizontal position, $x$ (m)','Interpreter','latex');
ylabel('Vertical position, $y$ (m)','Interpreter','latex');
title(sprintf('Projectile Fired at $\\theta$ = %.2f$^\\circ$ Hitting the Target',theta*180/pi),'Interpreter','latex');
set(gca,'TickLabelInterpreter','latex','FontSize',16);
legend('Interpreter','latex','Location','northwest','FontSize',14);
exportgraphics(fig2,fullfile(fig_dir,'projectile_collision.png'),'Resolution',300);


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
