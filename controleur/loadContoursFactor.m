function loadContoursFactor(~,~,obj)
try
    [factor, leg] = colorFactorPrompt(obj);

    polygonList = getPolygonsFromFactors(obj.model, factor);

    x = columnIndex(obj.model.factorTable, factor);
    levels = obj.model.factorTable.levels{x};

    set(obj.handles.axes{obj.handles.tabs.Selection}, 'userdata', {factor levels leg});

    showContoursFactor(obj, polygonList, levels, leg);
catch 
end
end