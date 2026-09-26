%Test function for Part 1 (3 inputs, 3 outputs)
%INPUTS:
%X: column vector [x1;x2;x3]
%OUTPUTS:
%f_val: f(X) as a 3x1 column vector
%J: the analytical Jacobian of f at X (3x3), where J(i,j) = df_i/dx_j
function [f_val,J] = test_function01(X)
    x1 = X(1);
    x2 = X(2);
    x3 = X(3);

    f1 = x1^2 + x2^2 - 6 - x3^5;
    f2 = x1*x3 + x2 - 12;
    f3 = sin(x1 + x2 + x3);

    f_val = [f1;f2;f3];

    % each row is the gradient of one output, each column is one input
    J = [2*x1, 2*x2, -5*x3^4;...
         x3, 1, x1;...
         cos(x1+x2+x3), cos(x1+x2+x3), cos(x1+x2+x3)];
end
