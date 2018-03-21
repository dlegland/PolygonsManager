function extractSelectedPolygons(frame)
%EXTRACTSELECTEDPOLYGONS Isolate the selected polygons and display them in a new frame
%
%   Inputs:
%       - frame: handle of the MainFrame
%
%   Outputs: none

model = frame.model;
nameArray = model.selectedPolygons;

selectedIndices = ismember(model.nameList, nameArray);

factorTbl = [];
if isa(model.factorTable, 'Table')
    % if there was already a factor Table loaded, update it to
    % match the new polygons
    
    factorTbl = model.factorTable(selectedIndices, :);
end

newData = selectPolygons(model.PolygonArray, selectedIndices);

% create the data model of the new frame
newModel = PolygonsManagerData('PolygonArray', newData, 'nameList', nameArray, 'factorTable', factorTbl);

% create a new mainframe
fen = PolygonsManagerMainFrame;

% setup the frame
setupNewFrame(fen, newModel);
