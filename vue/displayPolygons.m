function displayPolygons(obj, polygonArray, axis)
%DISPLAYPOLYGONS  Display the current polygons
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - polygonArray : a N-by-1 cell array containing the polygons
%   Outputs : none

set(obj.handles.submenus{4}{1}, 'checked', 'on');
set(obj.handles.submenus{4}{2}, 'checked', 'off');

co = axis.ColorOrder;

if length(co) > length(obj.model.nameList)
    set(axis, 'colororder', co(floor(1:length(co)/(length(obj.model.nameList)):length(co)), :));
end
set(axis, 'colororderindex', 1);

axis.UserData = 0;
delete([obj.handles.lines{1}{:}]);
delete([obj.handles.legends{:}]);

hold(axis, 'on');
for i = 1:length(polygonArray)
    obj.handles.lines{1}{i} = drawPolygon(polygonArray{i}, 'parent', axis, ...
                                             'ButtonDownFcn', {@detectLineClick, obj}, ...
                                                       'tag', obj.model.nameList{i});
end
hold(axis, 'off');

set(axis, 'colororder', co);

if ~isempty(obj.model.selectedPolygons)
    updateSelectedPolygonsDisplay(obj);
end
end