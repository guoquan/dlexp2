function [ layer ] = getMatInputLayer( source )
%GETMATINPUTLAYER Summary of this function goes here
%   Detailed explanation goes here

    data_ = load(source);
    
	layer.init = @() [];
    layer.forward = @(~, ~) data_;

end
