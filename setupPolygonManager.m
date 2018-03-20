function setupPolygonManager(varargin)
%SETUPPOLYGONMANAGER  One-line description here, please.
%
%   output = setupPolygonManager(input)
%
%   Example
%   setupPolygonManager
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-03-19,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2018 INRA - Cepia Software Platform.

% extract library path
fileName = mfilename('fullpath');
libDir = fileparts(fileName);

moduleNames = {...
    'model', ...
    'view', ...
    'controller'};

disp('Installing PolygonsManager Application ');
addpath(libDir);

% add all library modules
for i = 1:length(moduleNames)
    name = moduleNames{i};
    fprintf('Adding module: %-15s', name);
    addpath(fullfile(libDir, name));
    disp(' (ok)');
end
