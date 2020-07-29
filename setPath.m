%adds vm code to the path
%(c) Myers Abraham Davis (Abe Davis), MIT\n'

function setPath()

err = 0;

mpath = mfilename('fullpath');					%returns path of current code
HOME = fileparts(mpath);						%

vmpath = fullfile(HOME,'vm');					%


addpath(HOME);
addpath(fullfile(HOME,'matlabPyrTools'));
addpath(vmpath);
addpath(fullfile(vmpath,'vmcompute'));
addpath(fullfile(vmpath,'vmget'));

fprintf('MatlabPyrTools by Eero P. Simoncelli added to path.\nVisual Microphone code by Abe Davis added to path.\n');