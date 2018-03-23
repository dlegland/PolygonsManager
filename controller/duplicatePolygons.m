function duplicatePolygons(frame)
%DUPLICATEPOLYGONS Duplicates the polygons and opens a new frame
%
%   Inputs:
%       - frame: handle of the MainFrame
%
%   Outputs: none

model = duplicate(frame.model);

PolygonsManagerMainFrame(model);
