function toggleMarkerDisplay(frame)
%TOGGLEMARKERDISPLAY  Toggle display of markers in panels
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

hMenuItem = frame.menuBar.view.markers.handle;
hContextMenu = frame.menuBar.contextPanel.markers.handle;

panel = getActivePanel(frame);
if strcmp(hMenuItem.Checked, 'off')
    set(hMenuItem, 'checked', 'on');
    set(hContextMenu, 'checked', 'on');
    
    panel.displayOptions.markers.visible = true;
    
    set(panel.handles.axis.Children, 'Marker', '+');
else
    set(hMenuItem, 'checked', 'off');
    set(hContextMenu, 'checked', 'off');
    
    panel.displayOptions.markers.visible = false;

    set(panel.handles.axis.Children, 'Marker', 'none');
end