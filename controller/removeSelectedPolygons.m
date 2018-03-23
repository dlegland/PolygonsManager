function removeSelectedPolygons(frame)
%REMOVESELECTEDPOLYGONS Remove the selected polygons from the selection
%
%   Inputs:
%       - frame: handle of the MainFrame
%
%   Outputs: none

model = frame.model;
removeSelectedPolygons(model);

refreshDisplay(frame);
