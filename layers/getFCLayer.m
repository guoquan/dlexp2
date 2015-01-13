function [ layer ] = getFCLayer( n_, m_, hasBias_ )
%GETFCLAYER Summary of this function goes here
%   Detailed explanation goes here
    if nargin < 3
        hasBias_ = true;
    end
    
    function theta = init % consider a standalone initializor in the future
        r = sqrt(6) / sqrt(n_ + m_ + 1);
        w = (rand(m_, n_) * 2 - 1) * r;
        if hasBias_
            b = zeros(m_, 1);
            theta = [w b];
        else
            theta = w;
        end
    end
    layer.init = @init;
    
    function [ y ] = forward(theta, x)
        if hasBias_
            %{
            w = theta(:, 1:end-1);
            b = theta(:, end);
            y = w * x;
            y = bsxfun(@plus, y, b);
            %}
            y = theta * [x; ones(1, size(x, 2))];
        else
            w = theta;
            y = w * x;
        end
    end
    layer.forward = @forward;
    
    function [ dw, dx ] = backward(w, dy, x, ~)
        if hasBias_
            %{
            dw = dy * x';
            db = sum(dy, 2);
            dw = [dw db];
            %}
            dw = dy * [x; ones(1, size(x, 2))]';
            dx = w(:, 1:end-1)' * dy;
        else
            dw = dy * x';
            dx = w' * dy;
        end
    end
    layer.backward = @backward;
end





