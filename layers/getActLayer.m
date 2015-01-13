function [ layer ] = getActLayer( func )
%GETACTLAYER Summary of this function goes here
%   Detailed explanation goes here
    layer.init = @() [];
    layer.forward = @(~, x) func.f(x);
    layer.backward = @(~, dy, x, y) dy .* func.df(x, y);
end
