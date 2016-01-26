function displayPolygons(obj, polygonArray, axis)
%DISPLAYPOLYGONS  Display the current polygons
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - polygonArray : a N-by-1 cell array containing the polygons
%       - axis : handle of the axis on which the lines will be drawn
%   Outputs : none

set(obj.handles.submenus{4}{1}, 'checked', 'on');
set(obj.handles.submenus{4}{2}, 'checked', 'off');
set(obj.handles.submenus{5}{1}, 'checked', 'on');
set(obj.handles.submenus{5}{2}, 'checked', 'off');

obj.handles.tabs.TabTitles{1} = 'Polygons';

set(axis, 'colororderindex', 1);

co = axis.ColorOrder;

if length(co) > length(obj.model.nameList)
    set(axis, 'colororder', co(floor(1:length(co)/(length(obj.model.nameList)):length(co)), :));
end

delete([obj.handles.lines{1}{:}]);
delete([obj.handles.legends{:}]);

hold(axis, 'on');
% h = waitbar(0,'Starting ...', 'name', 'Drawing polygons');
% 
% N = length(polygonArray);
% tic;
for i = 1:length(polygonArray)
    name = obj.model.nameList{i};
    obj.handles.lines{1}{i} = drawPolygon(polygonArray{i}, 'parent', axis, ...
                                             'ButtonDownFcn', {@detectLineClick, obj}, ...
                                                       'tag', name);
%     tic;
%     waitbar(i / N, h, ['process : ' name]);
%     toc;
end
% toc;
% close(h)
hold(axis, 'off');

set(axis, 'colororder', co);

if ~isempty(obj.model.selectedPolygons)
    updateSelectedPolygonsDisplay(obj);
end
end