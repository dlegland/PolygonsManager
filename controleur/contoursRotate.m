function contoursRotate(~,~, obj, angle, type)
%CONTOURSROTATE  Rotate the polygons 
%
%   Inputs :
%       - ~ (not used) : inputs automatically send by matlab during a callback
%       - obj : handle of the MainFrame
%       - angle : variable that defines the rotation angle (clockwise) -> Values : 
%                   - 1 : 90°
%                   - 2 : 270°
%                   - 3 : 180°
%   Outputs : none

switch type
    case 1
        polygonArray = obj.model.nameList;
    case 2
        polygonArray = obj.model.selectedPolygons;
end 
h = waitbar(0,'Début de la conversion');
for i = 1:length(polygonArray)
    name = polygonArray{i};
    
    poly = getPolygonFromName(obj.model, name);
    
    switch angle
        case 1
            polyRot = [poly(:,2) -poly(:,1)];
        case 2
            polyRot = [-poly(:,2) poly(:,1)];
        case 3
            polyRot = [-poly(:,1) -poly(:,2)];
    end
    updatePolygon(obj.model.PolygonArray, getPolygonIndexFromName(obj.model, name), polyRot);
    waitbar(i / length(obj.model.nameList), h, ['process : ' name]);
end
disp(pi/4);
disp(45*pi/180);
close(h) 
ud = obj.handles.axes{obj.handles.tabs.Selection}.UserData;
if iscell(ud)
    polygonList = getPolygonsFromFactor(obj.model, ud{1});
    displayPolygonsFactor(obj, polygonList, ud{2}, ud{3});
else
    displayPolygons(obj, getAllPolygons(obj.model.PolygonArray));
end
end