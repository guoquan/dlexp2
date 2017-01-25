function [ layer ] = getReshapeLayer( varargin )
%GETRESHAPELAYER Summary of this function goes here
%   Detailed explanation goes here
    
    layer.init = @() [];
    
    function [ y ] = forward(~, x)
        y = reshape(x, varargin);
    end
    layer.forward = @forward;
    
    function [ dw, dx ] = backward(~, dy, ~, ~)
        dw = [];
        dx = reshape(dy, varargin);
    end
    layer.backward = @backward;
end





