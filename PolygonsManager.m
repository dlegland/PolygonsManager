%POLYGONSMANAGER Launch the PolygonsManager application
%
%   Usage:
%     PolygonsManager
%
%   Example
%      PolygonsManager
%
%   See also
%     PolygonsManagerMainFrame
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-03-19,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2018 INRA - Cepia Software Platform.

if ~exist('PolygonsManagerMainFrame', 'class')
    setupPolygonManager;
end

PolygonsManagerMainFrame;
