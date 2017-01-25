function [ A ] = col2nd( B, input_size, patch_size, stride )
%COL2ND Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4
    stride = [];
end

[m, n] = size(B);

if prod(patch_size) ~= m,
    error('The column size of B not consistent with patch_size.');
end

nd = numel(input_size); % same as ndims(A)
if numel(patch_size) < nd
    patch_size = [patch_size(:)' ones(1, nd - numel(patch_size))];
end
if numel(stride) < nd
    stride = [stride(:)' ones(1, nd - numel(stride))];
end

if prod((input_size - patch_size) ./ stride + 1) ~= n
    error('The row size of B not consistent with input_size and patch_size.');
end

A = reshape(B', [(input_size - patch_size) ./ stride + 1, m]);

end
