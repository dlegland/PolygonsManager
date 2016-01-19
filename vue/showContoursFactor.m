function showContoursFactor(obj, files, legends, display)
index = obj.handles.tabs.Selection;

% updatePanel(obj, index);
set(obj.handles.axes{index}, 'colororderindex', 1);

lineHandles = cell(1, length(legends));

delete([obj.handles.lines{:}]);
legend('off');

hold(obj.handles.axes{index}, 'on');
for i = 1:length(files)
    obj.handles.lines{i} = drawPolygon(files{i, 2}, 'parent', obj.handles.axes{index}, ...
                                   'ButtonDownFcn', @mouseClicker, ...
                                             'tag', obj.model.nameList{i}, ...
                                           'color', obj.handles.axes{index}.ColorOrder(files{i, 1}, :));
    if cellfun('isempty',lineHandles(files{i, 1}))
        test = obj.handles.lines{i};
        lineHandles{files{i, 1}} = test;
    end
end

hold(obj.handles.axes{index}, 'off');
if ~isempty(obj.model.selectedPolygons)
    selection(obj);
end
if display == 0
    legend(obj.handles.axes{index}, [lineHandles{:}], legends, 'location', 'eastoutside');
end
disp(get(obj.handles.axes{index}));

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
        selection(obj);
        set(obj.handles.list, 'value', find(ismember(obj.model.nameList, obj.model.selectedPolygons)));
    end
end