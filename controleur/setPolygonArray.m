function setPolygonArray(obj, nameArray, polygonArray)
    polygons = BasicPolygonArray(polygonArray);
    obj.model = Model(polygons, nameArray);
    if isempty(obj.handles.panels);
        createPanel(obj,obj.handles.tabs.Selection + 1);
    end
    set(obj.handles.list, 'string', nameArray);
    set([obj.handles.menus{:}], 'enable', 'on');
    set(obj.handles.submenus{1}, 'enable', 'on');
    showContours(obj);
end