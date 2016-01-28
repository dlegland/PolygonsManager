function computePCA(obj)

if ~isa(obj.model.PolygonArray, 'BasicPolygonArray')
    obj.model.pca = Pca(Table.create(getDatas(obj.model.PolygonArray), 'rowNames', obj.model.nameList'), 'Display', 'none');
end

% createPanel(obj, length(obj.handles.tabs.Children)+1, 'on');
% loadingPlot(obj.model.pca,obj.handles.axes{length(obj.handles.tabs.Children)},1,2, 'showNames', 0);

updateMenus(obj);
end