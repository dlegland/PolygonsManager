function toggleGridDisplay(frame)
%TOGGLEGRIDDISPLAY  One-line description here, please.
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

% get menu handles
hMenuItem = frame.menuBar.view.grid.handle;
hContextMenu = frame.menuBar.contextPanel.grid.handle;

panel = getActivePanel(frame);
if strcmp(hMenuItem.Checked, 'off')
    set(hMenuItem, 'checked', 'on');
    set(hContextMenu, 'checked', 'on');
    panel.displayOptions.grid.visible = true;
    
    set(panel.handles.axis, 'xgrid', 'on');
    set(panel.handles.axis, 'ygrid', 'on');
else
    set(hMenuItem, 'checked', 'off');
    set(hContextMenu, 'checked', 'off');
    panel.displayOptions.grid.visible = false;

    set(panel.handles.axis, 'xgrid', 'off');
    set(panel.handles.axis, 'ygrid', 'off');
end