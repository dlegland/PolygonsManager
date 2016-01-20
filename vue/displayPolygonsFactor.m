function displayPolygonsFactor(obj, polygonArray)
%DISPLAYPOLARSIGNATURE  Display the current polygons colored by factors
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - polygonArray : a N-by-1 cell array containing the polygons
%   Outputs : none


set(obj.handles.axes{1}, 'colororderindex', 1);

lineHandles = cell(1, length(obj.handles.axes{1}.UserData{2}));
delete([obj.handles.lines{1}{:}]);
delete([obj.handles.legends{:}]);

hold(obj.handles.axes{1}, 'on');
for i = 1:length(polygonArray)
    obj.handles.lines{1}{i} = drawPolygon(polygonArray{i, 2}, 'parent', obj.handles.axes{1}, ...
                                      'ButtonDownFcn', @mouseClicker, ...
                                                'tag', obj.model.nameList{i}, ...
                                              'color', obj.handles.axes{1}.ColorOrder(polygonArray{i, 1}, :));
                                         
    if cellfun('isempty',lineHandles(polygonArray{i, 1}))
        line = obj.handles.lines{1}{i};
        lineHandles{polygonArray{i, 1}} = line;
    end
end
hold(obj.handles.axes{1}, 'off');

if ~isempty(obj.model.selectedPolygons)
    updateSelectedPolygonsDisplay(obj);
end
if obj.handles.axes{1}.UserData{3} == 0
    obj.handles.legends{1} = legend(obj.handles.axes{1}, [lineHandles{:}], obj.handles.axes{1}.UserData{2}, 'location', 'eastoutside');
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