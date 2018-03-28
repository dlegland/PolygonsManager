function removeSelectedPolygons(frame)
%REMOVESELECTEDPOLYGONS Remove the selected polygons from the selection
%
%   Inputs:
%       - frame: handle of the MainFrame
%
%   Outputs: none

if strcmp(get(frame.handles.list, 'visible'), 'on')
    set(frame.handles.list, 'value', []);
end

model = frame.model;
removeSelectedPolygons(model);

refreshDisplay(frame);
