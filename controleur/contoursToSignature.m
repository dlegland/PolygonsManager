function contoursToSignature(~,~, obj)

angles = 90:449;
dat = zeros(length(obj.model.nameList), 360);

h = waitbar(0,'Conversion starting ...', 'name', 'Conversion');
for i = 1:length(obj.model.nameList)
    
    name = obj.model.nameList{i};

    obj.model.selectedPolygons = name;
    selection(obj);
    set(obj.handles.list, 'value', find(strcmp(name, obj.model.nameList)));
    
    waitbar(i / length(obj.model.nameList), h, ['process : ' name]);
    
    poly = getPolygonFromName(obj.model, name);
    
    sign = polygonSignature(poly, angles);
    
    dat(i, 1:length(sign)) = sign(:);
end
close(h);

fen = MainFrame;
polygons = PolarSignatureArray(dat, angles);
setPolygonArray(fen, obj.model.nameList, polygons);

end