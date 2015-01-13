function [ layer ] = getEuclideanScoreLayer( )
%GETSOFTMAXScoreLayer Summary of this function goes here
%   Detailed explanation goes here
    layer.init = @() [];
    layer.forward = @forward;
    layer.backward = @backward;

end

function cost = forward(~, inputs)
    h = inputs{1};
    y = inputs{2};
    cost = sum(sum((y - h).^2)) ./ (2 * size(y, 2));
end

function [g] = backward(~, ~, inputs, ~)
    h = inputs{1};
    y = inputs{2};
    g{1} = (h - y) ./ size(y, 2); % return gradient for both part of input
    g{2} = (y - h) ./ size(y, 2);
end
