% include setup global env and include all sub folders in the project

% setup the global env
global env

env.version = [0 0 0 1]; % v0.0.0.1
env.verbose = 5; % 0 - MUTE, 1 - ERROR, 2 - WARN, 3 - INFO, 4 - DEBUG, 5 - VERBOSE

env.log.file = 1; % 1 - stdout, 2 - stderr, [other file discriptors]

% get root identified by this script
[env.root, ~, ~] = fileparts(mfilename('fullpath'));
% set dependency path
env.depend = {};

% add to path
addpath(genpath(env.root), env.depend{:});
