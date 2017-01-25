function [ layer ] = getSoftmaxScoreLayer( )
%GETSOFTMAXScoreLayer Summary of this function goes here
%   Detailed explanation goes here
    layer.init = @() [];
    layer.forward = @forward;
    layer.backward = @backward;

end

function [ cost ] = forward(~, inputs)
    z = inputs{1};
    y = inputs{2};
    
    z = bsxfun(@minus, z, max(z,[],1));
    z(z > 709) = 709; % prevent overflow
    ez = exp(z);
    h = bsxfun(@rdivide, ez, sum(ez));
    h(h == 0) = eps;
    
    cost = -sum(sum(y .* log(h))) ./ size(y, 2);
end

function [ dw, delta ] = backward(~, ~, inputs, ~)
    z = inputs{1};
    y = inputs{2};
    
    z = bsxfun(@minus, z, max(z,[],1));
    ez = exp(z);
    h = bsxfun(@rdivide, ez, sum(ez));
    
    dw = [];
    
    delta{1} = (h - y) ./ size(y, 2);
    delta{2} = (y - h) ./ size(y, 2); % FIXME NOT SURE
end
