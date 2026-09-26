%Part 2: basic multidimensional Newton's method on test_function01
%hard coded for this one function with no safeguards or early stopping,
%just making sure the update step works. multi_newton_solver.m is the
%general version of this

X = [1;2;3]; % initial guess

for n = 1:20
    [F,J] = test_function01(X);

    % newton step, J\F instead of inv(J)*F
    X = X - J\F;
end

fprintf('root estimate: X = [%.10f; %.10f; %.10f]\n',X(1),X(2),X(3));

% plug the root back in, should be a vector of zeros
disp('test_function01 at the root:')
disp(test_function01(X))
