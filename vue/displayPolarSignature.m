function displayPolarSignature(obj, files)
index = obj.handles.tabs.Selection;  

set(obj.handles.axes{index}, 'colororderindex', 1);
xlim(obj.handles.axes{index}, [files.angleList(1), files.angleList(end)]);
ylim(obj.handles.axes{index}, [0 max(obj.model.PolygonArray.signatures(:))+.5]);
obj.handles.axes{index}.UserData = 0;
% delete([obj.handles.lines{index, :}]);
legend('off');

hold on;
for i = 1:getPolygonNumber(files)
    signature = getSignature(files, i);
    plot(obj.model.PolygonArray.angleList, signature, 'parent', obj.handles.axes{index}, ...
                                          'ButtonDownFcn', @mouseClicker, ...
                                                    'tag', obj.model.nameList{i});
end
hold off;
if ~isempty(obj.model.selectedPolygons)
    selection(obj);
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
        selection(obj);
        set(obj.handles.list, 'value', find(ismember(obj.model.nameList, obj.model.selectedPolygons)));
    end
end