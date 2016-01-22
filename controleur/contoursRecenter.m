function contoursRecenter(~,~, obj)
%CONTOURSRECENTER  Recenter the contour
%
%   Inputs :
%       - ~ (not used) : inputs automatically send by matlab during a callback
%       - obj : handle of the MainFrame
%   Outputs : none

% preallocating memory
polygonList = cell(1, length(obj.model.nameList));

% create waitbar
h = waitbar(0,'Début de la conversion');
for i = 1:length(polygonList)
    % get the name of the contours that will be centered
    name = obj.model.nameList{i};
    
    % get the polygon from its name
    poly = getPolygonFromName(obj.model, name);
    
    % recenter the polygon
    center  = polygonCentroid(poly);
    poly = bsxfun(@minus, poly, center);
    
    %update the polygon and the waitbar
    updatePolygon(obj.model.PolygonArray, getPolygonIndexFromName(obj.model, name), poly);
    waitbar(i / length(polygonList), h, ['process : ' name]);
end
% close waitbar
close(h) 
% get the selected factor
ud = obj.model.selectedFactor;
% if a factor was selected prior to the conversion
if iscell(ud)
    % display the contours colored depending on the selected factor
    polygonList = getPolygonsFromFactor(obj.model, ud{1});
    displayPolygonsFactor(obj, polygonList, obj.handles.axes{1});
else
    % display the contours without special coloration
    displayPolygons(obj, getAllPolygons(obj.model.PolygonArray), obj.handles.axes{1});
end