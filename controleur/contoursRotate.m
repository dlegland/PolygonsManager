function contoursRotate(obj, angle, type)
%CONTOURSROTATE  Rotate the contour 
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - angle : variable that defines the rotation angle (clockwise) -> Values : 
%                   - 1 : 90°
%                   - 2 : 270°
%                   - 3 : 180°
%       - type : determines which polygons must be rotated
%   Outputs : none

% determine which polygons will be rotated
switch type
    case 'all'
        % all the polygons
        polygonArray = obj.model.nameList;
    case 'selected'
        % only the polygons selected by the user
        polygonArray = obj.model.selectedPolygons;
end 

if ~isempty(polygonArray)
    
    for i = 1:length(polygonArray)
        % get the name of the contours that will be rotated
        name = polygonArray{i};

        % get the polygon from its name
        poly = getPolygonFromName(obj.model, name);
        
        % rotate the polygon
        switch angle
            case 1
                % 90°
                polyRot = [poly(:,2) -poly(:,1)];
            case 2
                % 270 °
                polyRot = [-poly(:,2) poly(:,1)];
            case 3
                % 180°
                polyRot = [-poly(:,1) -poly(:,2)];
        end
        
        %update the polygon
        updatePolygon(obj.model.PolygonArray, getPolygonIndexFromName(obj.model, name), polyRot);
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
end