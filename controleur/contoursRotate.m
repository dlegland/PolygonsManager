function contoursRotate(~,~, obj, angle, type)
%CONTOURSROTATE  Rotate the contour 
%
%   Inputs :
%       - ~ (not used) : inputs automatically send by matlab during a callback
%       - obj : handle of the MainFrame
%       - angle : variable that defines the rotation angle (clockwise) -> Values : 
%                   - 1 : 90°
%                   - 2 : 270°
%                   - 3 : 180°
%       - type : determines if the range of the rotation -> Values :
%                   - 1 : All polygons
%                   - 2 : Selected polygons
%   Outputs : none

% determine which polygons will be rotated
switch type
    case 1
        % all the polygons
        polygonArray = obj.model.nameList;
    case 2
        % only the polygons selected by the user
        if ~isempty(obj.model.selectedPolygons)
            polygonArray = obj.model.selectedPolygons;
        end
end 

if ~isempty(polygonArray)
    % create waitbar
    h = waitbar(0,'Début de la conversion');
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
        
        %update the polygon and the waitbar
        updatePolygon(obj.model.PolygonArray, getPolygonIndexFromName(obj.model, name), polyRot);
        waitbar(i / length(obj.model.nameList), h, ['process : ' name]);
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
end