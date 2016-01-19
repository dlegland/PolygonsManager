function contoursConvertPxMm(~,~, obj)

polygonList = cell(1, length(obj.model.nameList));
try
resol = contoursConvertPxMmPrompt;

h = waitbar(0,'Conversion starting ...', 'name', 'Conversion');
for i = 1:length(polygonList)

    name = obj.model.nameList{i};

    poly = getPolygonFromName(obj.model, name);

    polyMm = poly * resol;
    
    updatePolygon(obj.model.PolygonArray, getPolygonIndexFromName(obj.model, name), polyMm);
    waitbar(i / length(polygonList), h, ['process : ' name]);
end
close(h) 
ud = obj.handles.axes{obj.handles.tabs.Selection}.UserData;
if iscell(ud)
    polygonList = getPolygonsFromFactors(obj.model, ud{1});
    showContoursFactor(obj, polygonList, ud{2}, ud{3});
else
    showContours(obj, getAllPolygons(obj.model.PolygonArray));
end
catch
end

end