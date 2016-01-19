function selection(obj)
    selected = obj.model.selectedPolygons;
    allHandleList = get(obj.handles.axes{obj.handles.tabs.Selection}, 'Children'); 
    set(allHandleList, 'LineWidth', .5);
    allTagList = get(allHandleList, 'tag');
    if ~isempty(allTagList)
        neededHandle = allHandleList(ismember(allTagList, selected));
        set(neededHandle, 'LineWidth', 3.5);
        uistack(neededHandle, 'top');
    end
end

