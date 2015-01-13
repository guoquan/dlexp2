function [ layer ] = getMemoryInputLayer( data_ )
%GETMATINPUTLAYER Summary of this function goes here
%   Detailed explanation goes here

	layer.init = @() [];
    layer.forward = @(~, ~) data_;

end
