function polygonsRecenter(obj)
%POLYGONSRECENTER  Recenter the contour
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% preallocating memory
polygonList = cell(1, length(obj.model.nameList));

% save the name of the function in the log variable
obj.model.usedProcess{end+1} = 'polygonsRecenter';

for i = 1:length(polygonList)
    % get the name of the contours that will be centered
    name = obj.model.nameList{i};
    
    % get the polygon from its name
    poly = getPolygonFromName(obj.model, name);
    
    % recenter the polygon
    center  = polygonCentroid(poly);
    poly = bsxfun(@minus, poly, center);
    
    % update the polygon
    updatePolygon(obj.model.PolygonArray, getPolygonIndexFromName(obj.model, name), poly);
    updatePolygonInfos(obj.model, name)
end
% get the selected factor
sf = obj.model.selectedFactor;

% if a factor was selected prior to the conversion
if iscell(sf)
    % display the contours colored depending on the selected factor
    polygonList = getPolygonsFromFactor(obj.model, sf{1});
    displayPolygonsFactor(obj.handles.Panels{1}, polygonList);
else
    % display the contours without special coloration
    displayPolygons(obj.handles.Panels{1}, getAllPolygons(obj.model.PolygonArray));
end