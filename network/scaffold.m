function [ network ] = scaffold( layers_, varargin )
%SCAFFOLD Scaffold the network and initial the callbacks.
%   network callbacks summary
%       init()
%       train()
%       test()
%       theta()
%   en-closure variables summary
%       layers_
%       layers_names_
%       graph_
%       theta_


%--- default
options.maxIter = 100;
options.alpha = 1;

%--- fill with configured option
options_in = struct(varargin{:});
f_list = fieldnames(options_in);
for i=1:length(f_list)
    f = f_list{i};
    options.(f) = options_in.(f);
end

layers_names_ = fieldnames(layers_);
logd(['Total number of layers: ' num2str(numel(layers_names_))]);
logv('Layers: ');
for layer_idx = 1:numel(layers_names_)
    logv([num2str(layer_idx) ' -> ' layers_names_{layer_idx}]);
end

% construct a graph to determine dependency (also check for acyclic)
logi('Construct layer graph.');
graph_ = logical(sparse(numel(layers_names_), numel(layers_names_)));
function find_depend(layer_idx, prec_name)
    % add a edge from preceding phase to current
    graph_(strcmp(prec_name, layers_names_), layer_idx) = 1;
end
for layer_idx = 1:numel(layers_names_)
    layer = layers_.(layers_names_{layer_idx});
    if isfield(layer, 'prec');
        strfunc(@(prec_name)(find_depend(layer_idx, prec_name)), layer.prec);
    end
end

logd(['Layer Graph: ' mat2str(graph_)]);
logv(['Graph: ' num2str(1:numel(layers_names_))]);
for layer_idx = 1:numel(layers_names_)
    logv([layers_names_{layer_idx} '(' num2str(layer_idx) ') - ' num2str(graph_(:, layer_idx)')]);
end

% do a topological sort to get a processing order
logi('Topological sort the layer graph.');
try
    % this function is from The MathWorks, Inc. MATLAB Bioinformatics Toolbox
    order_ = graphtopoorder(graph_);
catch err
    loge([err.message '\n' ...
        'Phases dependency cannot be validated to be a DAG (directed acyclic graph).']);
end
logd(['Layer order: ' num2str(order_)]);
for ord_idx = 1:numel(order_)
    logv([layers_names_{order_(ord_idx)} '(' num2str(order_(ord_idx)) ') - ' num2str(graph_(:, order_(ord_idx))')]);
end

theta_ = struct();

% init callback
%   initialize theta for each layer
%   if override is true, existing theta will be override
%   turn override false if you want to 'set theta'
function init(override)
    if nargin < 1
        override = false;
    end
    for init_idx = order_
        if override || (~isfield(theta_, layers_names_{init_idx}))
            theta_.(layers_names_{init_idx}) = layers_.(layers_names_{init_idx}).layer.init();
        end
    end
end
network.init = @init;

% train callback
%
function train()
    for iter_idx = 1:options.maxIter
        state = struct();

        % forward pass
        for train_layer_idx = order_
            theta = theta_.(layers_names_{train_layer_idx});
            depends = sum(graph_(:, train_layer_idx));
            if depends == 0
                x = [];
            elseif depends == 1
                x = state(graph_(:, train_layer_idx)).y;
            else
                x = cell(1, depends);
                for dep_idx = 1:depends
                    x{dep_idx} = state(strcmp(layers_.(layers_names_{train_layer_idx}).prec{dep_idx}, layers_names_)).y;
                end
            end

            y = layers_.(layers_names_{train_layer_idx}).layer.forward(theta, x);

            state(train_layer_idx).y = y;
            state(train_layer_idx).dy = 0;%zeros(size(y));
        end

        % score
        logi(['Iter ' num2str(iter_idx) ': ' layers_names_{order_(end)} '=' num2str(state(order_(end)).y)]);

        % backward pass
        for train_layer_idx = order_(numel(order_):-1:1)
            if isfield(layers_.(layers_names_{train_layer_idx}).layer, 'backward')
                theta = theta_.(layers_names_{train_layer_idx});
                dy = state(train_layer_idx).dy;
                depends = sum(graph_(:, train_layer_idx));
                if depends == 0
                    x = [];
                elseif depends == 1
                    x = state(graph_(:, train_layer_idx)).y;
                else
                    x = cell(1, depends);
                    for dep_idx = 1:depends
                        x{dep_idx} = state(strcmp(layers_.(layers_names_{train_layer_idx}).prec{dep_idx}, layers_names_)).y;
                    end
                end
                y = state(train_layer_idx).y;

                if nargout(layers_.(layers_names_{train_layer_idx}).layer.backward) == 2
                    [dw, dx] = layers_.(layers_names_{train_layer_idx}).layer.backward(theta, dy, x, y);
                    state(train_layer_idx).dw = dw;
                else
                    dx = layers_.(layers_names_{train_layer_idx}).layer.backward(theta, dy, x, y);
                end

                depends = sum(graph_(:, train_layer_idx));
                if depends == 0
                    % pass
                elseif depends == 1
                    depend_idx = find(graph_(:, train_layer_idx));
                    state(depend_idx).dy ...
                        = state(depend_idx).dy ...
                        + dx;
                else
                    for dx_idx = 1:depends
                        depend_idx = strcmp(layers_.(layers_names_{train_layer_idx}).prec{dx_idx}, layers_names_);
                        state(depend_idx).dy ...
                            = state(depend_idx).dy ...
                            + dx{dx_idx};
                    end
                end
            end
        end

        % update
        for train_update_idx = order_
            theta_.(layers_names_{train_update_idx}) ...
                = theta_.(layers_names_{train_update_idx}) ...
                - options.alpha * state(train_update_idx).dw;
        end
    end
end
network.train = @train;

function out = forward()
    state = struct();
    for train_layer_idx = order_
        theta = theta_.(layers_names_{train_layer_idx});
        depends = sum(graph_(:, train_layer_idx));
        if depends == 0
            x = [];
        elseif depends == 1
            x = state(graph_(:, train_layer_idx)).y;
        else
            x = cell(1, depends);
            for dep_idx = 1:depends
                x{dep_idx} = state(strcmp(layers_.(layers_names_{train_layer_idx}).prec{dep_idx}, layers_names_)).y;
            end
        end

        y = layers_.(layers_names_{train_layer_idx}).layer.forward(theta, x);

        state(train_layer_idx).y = y;
    end
    out = state(order_(end)).y;
end
network.forward = @forward;

% test callback
%
function test()
    % TODO
end
network.test = @test;

% theta callback
%
function theta = get_theta()
    theta = theta_;
end
network.theta = @get_theta;

% set_theta callback
%   only the layers share the same name in both
%   theta and the network will be assign.
function set_theta(theta)
    theta_names = fieldnames(theta);
    for theta_idx = 1:numel(theta_names)
        field_name = theta_names{theta_idx};
        if isfield(layers_, field_name)
            theta_.(field_name) = theta.(field_name);
        end
    end
end
network.set_theta = @set_theta;
end
