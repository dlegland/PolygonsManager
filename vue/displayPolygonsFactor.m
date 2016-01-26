function displayPolygonsFactor(obj, polygonArray, axis)
%DISPLAYPOLYGONSFACTOR  Display the current polygons colored by factors
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - polygonArray : a N-by-1 cell array containing the polygons
%       - axis : handle of the axis on which the lines will be drawn
%   Outputs : none

set(obj.handles.submenus{4}{2}, 'checked', 'on');
set(obj.handles.submenus{4}{1}, 'checked', 'off');
set(obj.handles.submenus{5}{2}, 'checked', 'on');
set(obj.handles.submenus{5}{1}, 'checked', 'off');

obj.handles.tabs.TabTitles{1} = 'Polygons';

set(axis, 'colororderindex', 1);

co = axis.ColorOrder;

set(axis, 'colororder', co(floor(1:length(co)/(length(obj.model.selectedFactor{2})):length(co)), :));

lineHandles = cell(1, length(obj.model.selectedFactor{2}));
delete([obj.handles.lines{1}{:}]);

hold(axis, 'on');
for i = 1:length(polygonArray)
    obj.handles.lines{1}{i} = drawPolygon(polygonArray{i, 2}, 'parent', axis, ...
                                      'ButtonDownFcn', {@detectLineClick, obj}, ...
                                                'tag', obj.model.nameList{i}, ...
                                              'color', axis.ColorOrder(polygonArray{i, 1}, :));
                                         
    if cellfun('isempty',lineHandles(polygonArray{i, 1}))
        line = obj.handles.lines{1}{i};
        lineHandles{polygonArray{i, 1}} = line;
    end
end
hold(axis, 'off');

set(axis, 'colororder', co);

if ~isempty(obj.model.selectedPolygons)
    updateSelectedPolygonsDisplay(obj);
end

if obj.model.selectedFactor{3} == 0
    obj.handles.legends{1} = legend(axis, [lineHandles{:}], obj.model.selectedFactor{2}, ...
                                                'location', 'best', ...
                                           'uicontextmenu', []);
end
end