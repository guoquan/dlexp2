function [ B ] = nd2col( A, patch_size, stride )
%ND2COL Sample patches from a n-dimensional tensor and arrange into columns
%   Detailed explanation goes here

if nargin < 3
    stride = [];
end

% fit block size
input_size = size(A);
nd = numel(input_size); % same as ndims(A)
if numel(patch_size) < nd
    patch_size = [patch_size(:)' ones(1, nd - numel(patch_size))];
end
if numel(stride) < nd
    stride = [stride(:)' ones(1, nd - numel(stride))];
end

dim_offset = cumprod(input_size);

% first block
subblock_size = cumprod(patch_size);
first_block = zeros(1, subblock_size(nd));
first_block(1:subblock_size(1)) = 1:patch_size(1);
for i = 2:nd
    first_block((subblock_size(i - 1) + 1):subblock_size(i)) = ...
        bsxfun(@plus, ...
            first_block(1:subblock_size(i - 1))', ...
            (1:(patch_size(i) - 1)) * dim_offset(i - 1) ...
        );
end

% start indices for each block
subcol_size = cumprod(floor((input_size - patch_size) ./ stride + 1)); % be careful with the stride
offset = zeros(1, subcol_size(nd));
offset(1:subcol_size(1)) = 0:stride(1):(input_size - patch_size(1));
for i = 2:nd
    offset((subcol_size(i - 1) + 1):subcol_size(i)) = ...
        bsxfun(@plus, ...
            offset(1:subcol_size(i - 1))', ...
            (stride(i):stride(i):(input_size(i) - patch_size(i))) * dim_offset(i - 1) ...
        );
end

% get it
B = A(bsxfun(@plus, first_block', offset));

end

