function [ layer ] = getCNNLayer( filter_size_, filter_num_, hasBias_, shareBias_ )
%GETCNNLAYER Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 3
        hasBias_ = false;
    end
    if nargin < 4
        shareBias_ = false;
    end
    
    function theta = init % consider a standalone initializor in the future
        r = sqrt(6) / sqrt(prod(filter_size_) + filter_num_ + 1);
        w = (rand(filter_num_, prod(filter_size_)) * 2 - 1) * r;
        
        if hasBias_
            if shareBias_
                b = []; % TODO
            else
                b = []; % TODO
            end
            theta = [w b];
        else
            theta = w;
        end
    end
    layer.init = @init;
    
    function [ y ] = forward_noBias(w, x)
        [m, n, k] = size(x);
        mm = m - filter_size_(1) + 1;
        nn = n - filter_size_(2) + 1;
        y = zeros(mm, nn, k);
        for sample_idx = 1:k % iterate each sample
            cols = im2col(x(:, :, sample_idx), filter_size_);
            feature = w * cols;
            y(:, :, sample_idx) = reshape(feature, mm, nn);
        end
    end
    function [ y ] = forward_sharedBias(theta, x)
        % TODO
    end
    function [ y ] = forward_localBias(theta, x)
        % TODO
    end
    if hasBias_
        if shareBias_
            layer.forward = @forward_sharedBias;
        else
            layer.forward = @forward_localBias;
        end
    else
        layer.forward = @forward_noBias;
    end
    
    function [ dw, dx ] = backward(w, dy, x, y)
        dw = [];
        dx = reshape(dy, varargin);
    end
    layer.backward = @backward;
end

