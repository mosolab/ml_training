function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));
%printf('Theta1_grad size : %d %d\n', size(Theta1_grad));
%printf('Theta2_grad size : %d %d\n', size(Theta2_grad));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

X = [ones(m, 1) X];


for i = 1:m

    % for forwardprop
    y_orig = zeros(1, num_labels)';

    % calculate forward prop
    xi = X(i,:);
    xh = 1 ./ (1+exp(-Theta1*xi'));
    xh = [1 xh'];
    h = 1./(1+exp(-Theta2*xh'));

    % calculate cost func
    y_orig(y(i)) = 1;
    J = J+((-y_orig)'*log(h) - (1-y_orig)'*log(1-h));

    % calculate backprop
    delta_3 = h - y_orig;

    tmp = xh .* (1-xh);
    delta_2 = (Theta2' * delta_3)' .* tmp;
    delta_2 = delta_2(2:end);

    tmp_delta_2 =  delta_3 * xh;
    tmp_delta_1 =  delta_2' * xi;

    Theta2_grad = Theta2_grad + tmp_delta_2;
    Theta1_grad = Theta1_grad + tmp_delta_1;

end;

J = J/m;

l1 = sum(Theta1(:,2:length(Theta1(1,:))).^2);
l2 = sum(Theta2(:,2:length(Theta2(1,:))).^2);
l1 = sum(l1);
l2 = sum(l2);

J = J + ((l1 + l2)*lambda)/(2*m);

% -------------------------------------------------------------

% =========================================================================
Theta1_grad(:, 2:end) = Theta1_grad(:, 2:end) + (Theta1(:, 2:end) * lambda);
Theta2_grad(:, 2:end) = Theta2_grad(:, 2:end) + (Theta2(:, 2:end) * lambda);
% Unroll gradients
grad = [Theta1_grad(:)/m ; Theta2_grad(:)/m];


end
