function [ string_out ] = struct2str( struct_in, isCompact )
%STRUCT2STR Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2
    isCompact = true;
end
isCompact = true;

fields = fieldnames(struct_in);

string_out = '';
if isCompact
    for f_idx = 1:numel(fields)
        string_out = [string_out fields{f_idx} ': '];
        element = struct_in.(fields{f_idx});
        if isnumeric(element)
            if numel(element) == 1
                string_out = [string_out num2str(element)];
            else
                string_out = [string_out '[...](' size(element) ')'];
            end
        elseif isstruct(element)
            string_out = [string_out '(struct)'];
        end
        string_out = [string_out ';'];
    end
else
    for f_idx = 1:numel(fields)
    end
end
end

