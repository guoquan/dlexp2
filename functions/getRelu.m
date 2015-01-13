function [ func ] = getRelu( )
%GETRELU Summary of this function goes here
%   Detailed explanation goes here
    func.f = @relu;
    func.df = @drelu;

end

function y = relu(x)
    y = zeros(size(x));
    y(x>0) = x(x>0);
end

function d = drelu(x, ~)
    d = zeros(size(x));
    d(x>0)=1;
end
