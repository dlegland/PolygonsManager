function displayPolygons(obj, polygonArray)
%DISPLAYPOLYGONS  Display the current polygons
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - polygonArray : a N-by-1 cell array containing the polygons
%   Outputs : none

set(obj.handles.submenus{4}{1}, 'checked', 'on');
set(obj.handles.submenus{4}{2}, 'checked', 'off');

co = obj.handles.axes{1}.ColorOrder;
if length(co) > length(obj.model.nameList)
    set(obj.handles.axes{1}, 'colororder', co(floor(1:length(co)/(length(obj.model.nameList)-1)-1:length(co)), :));
end
set(obj.handles.axes{1}, 'colororderindex', 1);

obj.handles.axes{1}.UserData = 0;
delete([obj.handles.lines{1}{:}]);
delete([obj.handles.legends{:}]);

hold(obj.handles.axes{1}, 'on');
for i = 1:length(polygonArray)
    obj.handles.lines{1}{i} = drawPolygon(polygonArray{i}, 'parent', obj.handles.axes{1}, ...
                                             'ButtonDownFcn', @mouseClicker, ...
                                                       'tag', obj.model.nameList{i});
end
hold(obj.handles.axes{1}, 'off');

set(obj.handles.axes{1}, 'colororder', co);

if ~isempty(obj.model.selectedPolygons)
    updateSelectedPolygonsDisplay(obj);
end

    function mouseClicker(h,~)
        modifiers = get(obj.handles.figure,'currentModifier');
        ctrlIsPressed = ismember('control',modifiers);
        if ~ctrlIsPressed
            if find(strcmp(get(h,'tag'), obj.model.selectedPolygons))
                if length(obj.model.selectedPolygons) == 1
                    obj.model.selectedPolygons(strcmp(get(h,'tag'), obj.model.selectedPolygons)) = [];
                else
                    obj.model.selectedPolygons = obj.model.nameList(strcmp(get(h,'tag'), obj.model.nameList));
                end
            else
                obj.model.selectedPolygons = obj.model.nameList(strcmp(get(h,'tag'), obj.model.nameList));
            end
        else
            if find(strcmp(get(h,'tag'), obj.model.selectedPolygons))
                obj.model.selectedPolygons(strcmp(get(h,'tag'), obj.model.selectedPolygons)) = [];
            else
                obj.model.selectedPolygons{end+1} = obj.model.nameList{strcmp(get(h,'tag'), obj.model.nameList)};
            end
        end
        updateSelectedPolygonsDisplay(obj);
        set(obj.handles.list, 'value', find(ismember(obj.model.nameList, obj.model.selectedPolygons)));
    end
end