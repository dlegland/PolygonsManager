function displayPolygons(obj, polygonArray, axis)
%DISPLAYPOLYGONS  Display the current polygons
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - polygonArray : a N-by-1 cell array containing the polygons
%       - axis : handle of the axis on which the lines will be drawn
%   Outputs : none

% update the checked values in the menu
set(obj.handles.submenus{4}{1}, 'checked', 'on');
set(obj.handles.submenus{4}{2}, 'checked', 'off');
set(obj.handles.submenus{6}{1}, 'checked', 'on');
set(obj.handles.submenus{6}{2}, 'checked', 'off');

% set the name of the tab
obj.handles.tabs.TabTitles{1} = 'Polygons';

% reset the position of the cursor in the axis' colormap
set(axis, 'colororderindex', 1);

% get the axis' colormap
co = axis.ColorOrder;

if length(co) > length(obj.model.nameList)
    % if there's less polygons than colors in the colormap
    % change the axis' colormap to get colors that are as different as
    % possible from eachother
    set(axis, 'colororder', co(floor(1:length(co)/(length(obj.model.nameList)):length(co)), :));
end

% delete all the lines already drawn on the axis and the legends
delete([obj.handles.lines{1}{:}]);
delete([obj.handles.legends{:}]);

hold(axis, 'on');
for i = 1:length(polygonArray)
    % draw the polygon on the axis
    obj.handles.lines{1}{i} = drawPolygon(polygonArray{i}, 'parent', axis, ...
                                             'ButtonDownFcn', {@detectLineClick, obj}, ...
                                                       'tag', obj.model.nameList{i});
end
hold(axis, 'off');

% reset the colomap for futur uses
set(axis, 'colororder', co);

if ~isempty(obj.model.selectedPolygons)
    % if at least one polygon was selected, update the view
    updateSelectedPolygonsDisplay(obj);
end
end