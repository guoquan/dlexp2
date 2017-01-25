function [ theta ] = batchbackpropogation( network, layers_names, order, theta, options )
%BATCHBACKPROPAGATION Summary of this function goes here
%   Detailed explanation goes here

    for iter_idx = 1:options.maxIter
        % forward pass
        [energy, state] = network.forward(theta);
        
        % energy
        logi(['Iter ' num2str(iter_idx) ': ' struct2str(energy)]);

        % backward pass
        state = network.backward(state, theta);

        % update
        for train_update_idx = order
            theta.(layers_names{train_update_idx}) ...
                = theta.(layers_names{train_update_idx}) ...
                - options.alpha * state(train_update_idx).dw;
        end
    end
end

