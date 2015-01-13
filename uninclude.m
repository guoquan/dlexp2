% uninclude clear the global env and remove all sub folders in the
% project (after using) to avoid any side-effect.

global env

% remove from path
rmpath(genpath(env.root), env.depend{:});

% clear env
clearvars -global env