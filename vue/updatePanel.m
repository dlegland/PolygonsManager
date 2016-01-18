function updatePanel(obj, index)
    delete(obj.handles.axes{index});

    myAxe = axes('parent', obj.handles.panels{index}, 'ButtonDownFcn', @reset);

    axis equal;

    obj.handles.axes{index} = myAxe;

    function reset(~,~)
        modifiers = get(obj.handles.figure,'currentModifier');
        ctrlIsPressed = ismember('control',modifiers);
        if ~ctrlIsPressed
            obj.model.selectedPolygons = {};
            set(obj.handles.list, 'value', []);
            selection(obj);
        end
    end
end
