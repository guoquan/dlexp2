function diff = gradientCheck(J, dJ, theta)
    numgrad = zeros(size(theta));

    epsilon = 1e-4;
    [m, n] = size(theta);
    e = eye(m);
    for i = 1:n
        for j = 1:m
            numgrad(j, i) = (J(theta(:, i) + epsilon * e(:, j)) - J(theta(:, i) - epsilon * e(:, j))) ./ (2  * epsilon);
        end
    end

    analgrad = dJ(theta, J(theta));

    diff = norm(numgrad - analgrad);
end
