function log_message( level, message )
%LOG_MESSAGE Show log message according to env setting
global env
if env.verbose >= level
    fprintf(env.log.file, '%s %10s: %s\n', datestr(now, 'yyyy-mm-dd HH:MM:SS.FFF'), ['(' num2level(level) ')'], message);
end
end

function [ level ] = num2level( num )
levels = {'ERROR', 'WARN', 'INFO', 'DEBUG', 'VERBOSE'};
if num < 0 || num > numel(levels)
	warning(['Unexpected log level number ' num2str(num) '. Use default (3).']);
    num = 3;
end
level = levels{num};
end

%{
function [ num_level ] = level2num( level )
switch level % ERROR, WARN, INFO, DEBUG, VERBOSE
    case 'ERROR'
        num_level = 1;
    case 'WARN'
        num_level = 2;
    case 'INFO'
        num_level = 3;
    case 'DEBUG'
        num_level = 4;
    case 'VERBOSE'
        num_level = 5;
    otherwise
        warning(['Unexpected log level ''' level '''. Use default (''INFO'').']);
        num_level = 3;
end
end
%}
