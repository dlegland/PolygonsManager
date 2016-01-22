function detectLineClick(h,~, obj)
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