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

v2 = frame.menuBar.view.markers.handle;
cp2 = frame.menuBar.contextPanel.markers.handle;

selectedTabs = frame.handles.tabs.Selection;
if strcmp(v2.Checked, 'off')
    set(v2, 'checked', 'on');
    set(cp2, 'checked', 'on');
    set(frame.handles.Panels{selectedTabs}.uiAxis.Children, 'Marker', '+');
else
    set(v2, 'checked', 'off');
    set(cp2, 'checked', 'off');
    set(frame.handles.Panels{selectedTabs}.uiAxis.Children, 'Marker', 'none');
end