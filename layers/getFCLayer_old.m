function [ layer ] = getFCLayer( n, m )
%GETFCLAYER Summary of this function goes here
%   Detailed explanation goes here
    
    layer.init = @() init(n, m);
    layer.forward = @(w, x) forward(w, x);
    layer.backward = @(w, dy, x, y) [backward(w, dy, x, y)];
end

function w = init(n, m) % consider a standalone initializor in the future
    r = sqrt(6) / sqrt(n + m + 1);
    w = (rand(m, n) * 2 - 1) * r;
end

function [ y ] = forward(w, x)
    y = w * x;
end

function [ dw, dx ] = backward(w, dy, x, ~)
    dw = dy * x';
    dx = w' * dy;
end
