function [ func ] = getSigmoid( )
%GETSIGMOID Summary of this function goes here
%   Detailed explanation goes here
    func.f = @sigmoid;
    func.df = @dsigmoid;

end

function y = sigmoid(x)
y = 1 ./ (1 + exp(-x));
end

function d = dsigmoid(~, y) 
d = y .* (1 - y);
end
