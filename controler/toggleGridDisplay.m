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

v1 = frame.menuBar.view.grid.handle;
cp1 = frame.menuBar.contextPanel.grid.handle;

selectedInds = frame.handles.tabs.Selection;
if strcmp(v1.Checked, 'off')
    set(v1, 'checked', 'on');
    set(cp1, 'checked', 'on');
    set(frame.handles.Panels{selectedInds}.uiAxis, 'xgrid', 'on');
    set(frame.handles.Panels{selectedInds}.uiAxis, 'ygrid', 'on');
else
    set(v1, 'checked', 'off');
    set(cp1, 'checked', 'off');
    set(frame.handles.Panels{selectedInds}.uiAxis, 'xgrid', 'off');
    set(frame.handles.Panels{selectedInds}.uiAxis, 'ygrid', 'off');
end