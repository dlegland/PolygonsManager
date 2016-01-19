function setPolygonArray(obj, nameArray, polygonArray)
    obj.model = Model(polygonArray, nameArray);
    if isempty(obj.handles.panels);
        createPanel(obj,obj.handles.tabs.Selection + 1, 1);
    end
    set(obj.handles.list, 'string', nameArray);
    set([obj.handles.menus{:}], 'enable', 'on');
    set(obj.handles.submenus{1}, 'enable', 'on');
    showContours(obj, getAllPolygons(obj.model.PolygonArray));
    if isa(polygonArray, 'PolarSignatureArray')
        createPanel(obj,obj.handles.tabs.Selection + 1, 0);
        displayPolarSignature(obj, polygonArray);
    end
end