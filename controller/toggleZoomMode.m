function toggleZoomMode(frame)
%TOGGLEZOOMMODE Toggle zoom mode and updates menus
%
%   Inputs:
%       - frame: instance of PolygonsManagerMainFrame
%   Outputs : none
%
%   Example
%   toggleGridDisplay
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-03-20,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2018 INRA - Cepia Software Platform.

v3 = frame.menuBar.view.zoom.handle;
cp3 = frame.menuBar.contextPanel.zoom.handle;

if strcmp(v3.Checked, 'off')
    set(v3, 'checked', 'on');
    set(cp3, 'checked', 'on');
    zoom('on');
else
    set(v3, 'checked', 'off');
    set(cp3, 'checked', 'off');
    zoom('off');
end