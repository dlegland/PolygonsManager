function rotate(~,~, obj, angle)

h = waitbar(0,'Début de la conversion');
for i = 1:length(obj.model.nameList)
    name = obj.model.nameList{i};
    
    poly = getPolygonFromName(obj.model, name);
    
    switch angle
        case 1
            polyRot = [poly(:,2) -poly(:,1)];
        case 2
            polyRot = [-poly(:,2) poly(:,1)];
        case 3
            polyRot = [-poly(:,1) -poly(:,2)];
    end
    updatePolygon(obj.model.PolygonArray, getPolygonIndexFromName(obj.model, name), polyRot);
    waitbar(i / length(obj.model.nameList), h, ['process : ' name]);
end
close(h) 
ud = obj.handles.axes{obj.handles.tabs.Selection}.UserData;
if iscell(ud)
    polygonList = getPolygonsFromFactors(obj.model, ud{1});
    showContoursFactor(obj, polygonList, ud{2}, ud{3});
else
    showContours(obj);
end
end