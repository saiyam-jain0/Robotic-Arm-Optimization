% Define forward kinematics equations
L1 = 1; % length of first link
L2 = 1; % length of second link

% Forward kinematics equations
fk_x = @(theta1, theta2) L1*cos(theta1) + L2*cos(theta1 + theta2);
fk_y = @(theta1, theta2) L1*sin(theta1) + L2*sin(theta1 + theta2);

% Define cost function (squared error)
cost_function = @(theta1, theta2, target_x, target_y) (fk_x(theta1, theta2) - target_x)^2 + (fk_y(theta1, theta2) - target_y)^2;

% Cauchy steepest descent method
alpha = 0.01; % step size
max_iterations = 1000; % maximum number of iterations
tolerance = 1e-6; % convergence tolerance

% Initial guess for joint angles
theta1 = 0; 
theta2 = 0;

% Desired end-effector position
target_x = input("x target");
target_y = input("y target");

% Optimization loop
for iter = 1:max_iterations
    % Calculate gradient of cost function
    grad_theta1 = (cost_function(theta1 + 1e-6, theta2, target_x, target_y) - cost_function(theta1, theta2, target_x, target_y))/1e-6;
    grad_theta2 = (cost_function(theta1, theta2 + 1e-6, target_x, target_y) - cost_function(theta1, theta2, target_x, target_y))/1e-6;
    
    % Update joint angles using steepest descent
    theta1 = theta1 - alpha * grad_theta1;
    theta2 = theta2 - alpha * grad_theta2;
    
    % Check for convergence
    if abs(grad_theta1) < tolerance && abs(grad_theta2) < tolerance
        break;
    end
end

% Display results
if iter == max_iterations
    disp('Maximum iterations reached without convergence');
else
    disp('Convergence achieved:');
    disp(['Theta1: ', num2str(theta1)]);
    disp(['Theta2: ', num2str(theta2)]);
end

% Calculate final end-effector position
final_x = fk_x(theta1, theta2);
final_y = fk_y(theta1, theta2);
disp(['Final End-effector position: (', num2str(final_x), ', ', num2str(final_y), ')']);